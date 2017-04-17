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
topic_build_status_changed = sns.Topic("arn:aws:sns:" + region + ":" + account + ":build_status_changed")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    # parse input
    sns_record = event["Records"][0]["Sns"]
    timestamp = sns_record["Timestamp"]
    build_scheduled_event = json.loads(sns_record["Message"])
    url = build_scheduled_event["url"]
    interaction_id = build_scheduled_event["interaction_id"]

    # publish event
    publish_event({"interaction_id": interaction_id, "url": url, "status": "finished"})

    logger.debug("Finished handling %s", str(event))


def publish_event(message):
    topic_build_status_changed.publish(Message=json.dumps(message))
