import json
import boto3
import hashlib
from shmenkins import logging, aws
from botocore.exceptions import ClientError

logger = logging.get_logger()
account = None  # type: str
topic_build_status_changed = None  # type: aws.Topic
cb = None


def handler(event: dict, ignored: dict) -> None:
    global account
    global topic_build_status_changed
    global cb

    if topic_build_status_changed is None:
        aws_ctx = aws.Aws()
        account = aws_ctx.get_account()
        topic_build_status_changed = aws_ctx.get_topic("build_status_changed")
        cb = boto3.client("codebuild")

    handle(event)


def handle(event: dict) -> None:
    logger.debug("Handling %s", str(event))

    # parse input
    sns_record = event["Records"][0]["Sns"]
    build_scheduled_event = json.loads(sns_record["Message"])
    url = build_scheduled_event["url"]
    interaction_id = build_scheduled_event["interaction_id"]

    try:
        project_name = put_project(url)
        build = cb_start_build(project_name)
        print(str(build))
        # publish event
        topic_build_status_changed.publish({"interaction_id": interaction_id, "url": url, "status": "started"})
    except Exception as e:
        logger.error("Failed to start build; project_name=%s, url=%s", url, e)
        topic_build_status_changed.publish({"interaction_id": interaction_id, "url": url, "status": "failed"})

    logger.debug("Finished handling %s", str(event))


def put_project(url: str) -> str:
    project_name = hashlib.sha256(url.encode()).hexdigest()  # type: str
    try:
        # update the cb project without checking if it exists first
        # most of the time the project is already there
        cb_update_project(project_name, url)
    except ClientError as e:
        if is_resource_not_found_error(e):
            logger.debug("Project not found; project_name=%s, url=%s", project_name, url)
            cb_create_project(project_name, url)
        else:
            raise e

    return project_name


def cb_start_build(project_name: str) -> dict:
    logger.debug("Starting build; project_name=%s", project_name)
    build = cb.start_build(projectName=project_name)  # type: dict
    logger.debug("Started build; project_name=%s, build=%s", project_name, build)

    return build


def is_resource_not_found_error(e: ClientError) -> bool:
    try:
        return e.response["Error"]["Code"] == "ResourceNotFoundException"
    except:
        return False


def cb_create_project(project_name: str, url: str) -> None:
    logger.debug("Creating build project; project_name=%s, url=%s", project_name, url)
    project = cb.create_project(
        name=project_name,
        description=url,
        source={"type": "GITHUB", "location": url},
        artifacts={"type": "NO_ARTIFACTS"},
        environment={"type": "LINUX_CONTAINER", "image": "rzhilkibaev/jst", "computeType": "BUILD_GENERAL1_SMALL"},
        serviceRole="arn:aws:iam::" + account + ":role/cb_general"
    )
    logger.debug("Created build project; project_name=%s, url=%s, project=%s", project_name, url, str(project))


def cb_update_project(project_name: str, url: str) -> None:
    logger.debug("Updating build project; project_name=%s, url=%s", project_name, url)
    project = cb.update_project(
        name=project_name,
        description=url,
        source={"type": "GITHUB", "location": url},
        artifacts={"type": "NO_ARTIFACTS"},
        environment={"type": "LINUX_CONTAINER", "image": "rzhilkibaev/jst", "computeType": "BUILD_GENERAL1_SMALL"},
        serviceRole="arn:aws:iam::" + account + ":role/cb_general"
    )
    logger.debug("Updated build project; project_name=%s, url=%s, project=%s", project_name, url, str(project))
