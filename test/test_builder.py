from __future__ import print_function
import boto3
import time
import shmenkins

def test_build_status_published():
    """ When a message posted to 'build_scheduled' topic
        then a buid status is published to 'build_status_changed' topic """
    shmenkins.topic_build_scheduled.publish(Message='{"interaction_id": "123", "url": "https://github.com/foo/bar"}')
    time.sleep(1)

    actual_item = shmenkins.table_sns_log.get_item(Key={"interaction_id": "123"}).get("Item")
    expected_item = {"interaction_id": "123", "url": "https://github.com/foo/bar"}
    assert actual_item == expected_item

