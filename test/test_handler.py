from __future__ import print_function
import os
import boto3
import time

region = boto3.session.Session().region_name
account = boto3.client("sts").get_caller_identity().get("Account")

topic_arn_build_scheduled = "arn:aws:sns:" + region + ":" + account + ":build_scheduled"

build_scheduled_event = {u'Records': [{u'EventVersion': u'1.0',
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

sns = boto3.client("sns")
table_sns_log = boto3.resource("dynamodb").Table("sns_log")

def test_build_status_published():
    sns.publish(TopicArn=topic_arn_build_scheduled, Message='{"interaction_id": "123", "url": "https://github.com/foo/bar"}')
    time.sleep(5)

    response = table_sns_log.get_item(Key={"interaction_id": "123"})
    expected_item = {"interaction_id": "123", "url": "https://github.com/foo/bar"}
    actual_item = response.get("Item")
    assert actual_item == expected_item

