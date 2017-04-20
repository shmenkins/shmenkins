from __future__ import print_function
import boto3
import time
import shmenkins
import uuid
import json

def test_build_status_published():
    """ When a message posted to 'build_scheduled' topic
        then a buid status is published to 'build_status_changed' topic """
    interaction_id = str(uuid.uuid4())
    build_scheduled_event = {
            "interaction_id": interaction_id,
            "url": "https://github.com/foo/bar"}
    shmenkins.topic_build_scheduled.publish(Message=json.dumps(build_scheduled_event))

    time.sleep(5)
    items = shmenkins.get_published_events(interaction_id)
    build_status_changed_events = [x for x in items if x["topic_name"] == "build_status_changed"]

    assert len(build_status_changed_events) == 1

