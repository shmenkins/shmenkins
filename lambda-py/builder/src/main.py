import boto3
import json
import logging
import os
from shmenkins import logging, aws

logger = logging.get_logger()

topic_build_status_changed = aws.Topic("build_status_changed")


def handler(event, context):
    logger.debug("Handling %s", str(event))

    # parse input
    sns_record = event["Records"][0]["Sns"]
    build_scheduled_event = json.loads(sns_record["Message"])
    url = build_scheduled_event["url"]
    interaction_id = build_scheduled_event["interaction_id"]

    # publish event
    topic_build_status_changed.publish({"interaction_id": interaction_id, "url": url, "status": "finished"})

    logger.debug("Finished handling %s", str(event))
