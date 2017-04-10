#!/usr/bin/env python2

from __future__ import print_function
import boto3
import logging
import os
import json

log_level = logging.INFO
logger = logging.getLogger()
logger.setLevel(log_level)

region = boto3.session.Session().region_name
account = boto3.client("sts").get_caller_identity().get("Account")

topic_arn_build_scheduled = "arn:aws:sns:" + region + ":" + account + ":build_scheduled"

sns = boto3.client("sns")

def build(url):
    message = json.dumps({"url": url})
    r = sns.publish(TopicArn=topic_arn_build_scheduled,
                Message=message)

    print(str(r))
    

if __name__ == "__main__":
    build("https://blah")
