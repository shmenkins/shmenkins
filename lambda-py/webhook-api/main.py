import boto3
import json
import logging
import os

topic_arn_build_request = os.environ["TOPIC_ARN_BUILD_REQUEST"]
log_level = os.environ.get("LOG_LEVEL")

if not log_level:
    log_level = logging.INFO

logger = logging.getLogger()
logger.setLevel(log_level)

sns = boto3.client("sns")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    publish_build_request_event("https://foo")

    logger.debug("Finished handling %s", str(event))


def publish_build_request_event(url):
    build_request_event = {
        "url": url
    }
    publish_event(topic_arn_build_request, build_request_event)


def publish_event(topic_arn, event):
    sns.publish(TopicArn=topic_arn, Message=json.dumps(event))
