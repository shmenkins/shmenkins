import boto3
import json
import logging
import os

topic_arn_build_status_change = os.environ["TOPIC_ARN_BUILD_STATUS_CHANGE"]
log_level = os.environ.get("LOG_LEVEL")

if not log_level:
    log_level = logging.INFO

logger = logging.getLogger()
logger.setLevel(log_level)

sns = boto3.client("sns")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    build_scheduled_event = parse_build_scheduled_event(event)

    publish_status_change_event(build_scheduled_event["url"], "finished")

    logger.debug("Finished handling %s", str(event))


def parse_build_scheduled_event(event):
    return json.loads(event["Records"][0]["Sns"]["Message"])


def publish_status_change_event(url, status):
    build_status_change_event = {
        "url": url,
        "status": status
    }
    publish_event(topic_arn_build_status_change, build_status_change_event)


def publish_event(topic_arn, event):
    sns.publish(TopicArn=topic_arn, Message=json.dumps(event))
