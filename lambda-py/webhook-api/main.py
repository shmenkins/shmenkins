import boto3
import json
import logging
import os
import uuid

log_level = os.environ.get("LOG_LEVEL")

if not log_level:
    log_level = logging.INFO

logger = logging.getLogger()
logger.setLevel(log_level)

region = boto3.session.Session().region_name
account = boto3.client("sts").get_caller_identity().get("Account")

sns = boto3.resource("sns")
topic_artifact_outdated = sns.Topic("arn:aws:sns:" + region + ":" + account + ":artifact_outdated")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    # parse input
    body = json.loads(event["body"])
    url = body["repository"]["url"]
    interaction_id = str(uuid.uuid4())

    # publish event
    publish_event({"interaction_id": interaction_id, "url": url})

    logger.debug("Finished handling %s", str(event))

    return {"statusCode": "201", "headers": {"X-Shmenkins-InteractionId": interaction_id}}


def publish_event(message):
    topic_artifact_outdated.publish(Message=json.dumps(message))
