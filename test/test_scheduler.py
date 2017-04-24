from __future__ import print_function
import boto3
import time
import shmenkins
import json
import requests
import config
import uuid


def test_when_artifact_outdated_then_artifact_scheduled():
    """ When a "artifact_outdated" message is received
        then a the artifact source repo url is published to 'build_scheduled' topic """

    interaction_id = str(uuid.uuid4())
    artifact_outdated_event = {
            "interaction_id": interaction_id,
            "url": "https://github.com/foo/bar"}
    shmenkins.topic_artifact_outdated.publish(Message=json.dumps(artifact_outdated_event))

    time.sleep(2)
    items = shmenkins.get_published_events(interaction_id)
    build_scheduled_events = [x for x in items if x["topic_name"] == "build_scheduled"]

    assert len(build_scheduled_events) == 1

