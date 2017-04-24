import boto3
import json
import logging
import os

log_level = os.environ.get("LOG_LEVEL")

if not log_level:
    log_level = logging.INFO

logger = logging.getLogger()
logger.setLevel(log_level)

region = boto3.session.Session().region_name
account = boto3.client("sts").get_caller_identity().get("Account")

sns = boto3.resource("sns")
topic_build_scheduled = sns.Topic("arn:aws:sns:" + region + ":" + account + ":build_scheduled")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    # parse input
    sns_record = event["Records"][0]["Sns"]
    artifact_outdated_event = json.loads(sns_record["Message"])
    url = artifact_outdated_event["url"]
    interaction_id = artifact_outdated_event["interaction_id"]

    # publish event
    publish_event({"interaction_id": interaction_id, "url": url})

    logger.debug("Finished handling %s", str(event))


def publish_event(message):
    topic_build_scheduled.publish(Message=json.dumps(message))
