import boto3
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

    message = "finished"
    sns.publish(TopicArn=topic_arn_build_status_change,
            Message=message)

    logger.debug("Finished handling %s", str(event))

