from __future__ import print_function
import os
import boto3
import time
import uuid
import json
from mock import MagicMock
from mock import patch
from nose.plugins.attrib import attr
from boto3.dynamodb.conditions import Key, Attr


region = "dummy-region"
account = "dummy-account"

import main

table_sns_log = boto3.resource("dynamodb").Table("sns_log")

def create_event():
    return {u'Records': [{u'EventVersion': u'1.0',
                       u'EventSubscriptionArn': u'arn:aws:sns:us-west-2:000000000000:build_scheduled:00000000-0000-0000-0000-000000000000',
                       u'EventSource': u'aws:sns',
                       u'Sns': {u'SignatureVersion': u'1', u'Timestamp': u'2017-04-10T05:12:56.297Z',
                                u'Signature': u'xxx',
                                u'SigningCertUrl': u'xxx',
                                u'MessageId': u'0000000000000-0000-0000-000000000000', u'Message': u'{"interaction_id": "123", "url": "https://github.com/foo/bar"}',
                                u'MessageAttributes': {
                                    u'AWS.SNS.MOBILE.MPNS.NotificationClass': {u'Type': u'String',
                                                                               u'Value': u'realtime'},
                                    u'AWS.SNS.MOBILE.WNS.Type': {u'Type': u'String', u'Value': u'wns/badge'},
                                    u'AWS.SNS.MOBILE.MPNS.Type': {u'Type': u'String', u'Value': u'token'}},
                                u'Type': u'Notification',
                                u'UnsubscribeUrl': u'xxx',
                                u'TopicArn': u'arn:aws:sns:us-west-2:000000000000:build_scheduled', u'Subject': None}}]}


@attr("local")
@patch("main.persist_item", MagicMock())
def test_persist_called():
    main.handler(create_event(), None)
    expected_item = {
            "interaction_id": "123",
            "timestamp": "2017-04-10T05:12:56.297Z",
            "message": {
                "interaction_id": "123",
                "url": "https://github.com/foo/bar"}}
    main.persist_item.assert_called_with(expected_item)
    assert main.table_sns_log.table_name == "sns_log"

@attr("integration")
def test_message_persisted_in_dynamo():
    """
    When any message posted to any topic
    then the message is persisted to 'sns_log' table
    with 'interaction_id' as the hash key and 'timestamp' as the range key
    """
    interaction_id = str(uuid.uuid4())
    # replace static interaction_id
    message = {"interaction_id": interaction_id, "url": "https://github.com/foo/bar"}
    event = create_event()
    event["Records"][0]["Sns"]["Message"] = json.dumps(message)

    main.handler(event, None)
    time.sleep(1)
    response = table_sns_log.query(KeyConditionExpression=Key("interaction_id").eq(interaction_id))
    expected_items = [{
            "interaction_id": interaction_id,
            "timestamp": "2017-04-10T05:12:56.297Z",
            "message": {
                "interaction_id": interaction_id,
                "url": "https://github.com/foo/bar"}}]
    #sample response
    #{u'Count': 1, u'Items': [{u'timestamp': u'2017-04-10T05:12:56.297Z', u'message': {u'url': u'https://github.com/foo/bar', u'interaction_id': u'123'}, u'interaction_id': u'123'}], u'ScannedCount': 1, 'ResponseMetadata': {'RetryAttempts': 0, 'HTTPStatusCode': 200, 'RequestId': '8P0NII0TI2UR8OVDCG0UJR0RNJVV4KQNSO5AEMVJF66Q9ASUAAJG', 'HTTPHeaders': {'x-amzn-requestid': '8P0NII0TI2UR8OVDCG0UJR0RNJVV4KQNSO5AEMVJF66Q9ASUAAJG', 'content-length': '202', 'server': 'Server', 'connection': 'keep-alive', 'x-amz-crc32': '3831536738', 'date': 'Mon, 17 Apr 2017 02:51:30 GMT', 'content-type': 'application/x-amz-json-1.0'}}}
    actual_items = response.get("Items")

    assert actual_items == expected_items

