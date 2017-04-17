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

    shmenkins_event = parse_shmenkins_event(event)

    persist_item(shmenkins_event)

    logger.debug("Finished handling %s", str(event))


def parse_shmenkins_event(event):
    return json.loads(event["Records"][0]["Sns"]["Message"])


def persist_item(item):
    table_sns_log.put_item(Item=item)
