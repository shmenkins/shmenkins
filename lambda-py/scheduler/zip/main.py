import boto3
import json
from shmenkins import logging, aws


logger = logging.get_logger()

topic_build_scheduled = aws.Topic("build_scheduled")


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
    topic_build_scheduled.publish(message)
