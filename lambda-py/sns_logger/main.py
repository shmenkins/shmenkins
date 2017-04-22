import boto3
import json
import logging
import os

log_level = os.environ.get("LOG_LEVEL")

if not log_level:
    log_level = logging.INFO

logger = logging.getLogger()
logger.setLevel(log_level)

table_sns_log = boto3.resource("dynamodb").Table("sns_log")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    sns_record = event["Records"][0]["Sns"]
    message_timestamp = sns_record["Timestamp"]
    # topic arn sample: 'arn:aws:sns:us-west-2:000000000000:build_scheduled'
    topic_name = sns_record["TopicArn"].split(":")[5]
    message = json.loads(sns_record["Message"])

    persist_item({
        "interaction_id": message["interaction_id"],
        "message_timestamp": message_timestamp,
        "topic_name": topic_name,
        "message": message})

    logger.debug("Finished handling %s", str(event))


def persist_item(item):
    table_sns_log.put_item(Item=item)
