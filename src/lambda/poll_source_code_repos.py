from __future__ import print_function
import boto3
import json

def lambda_handler(event, context):

    print("Received event: " + json.dumps(event, indent=2))

    s3 = boto3.client('s3')
    s3_bucket = "shmenkins"
    s3_key = "cfg/source-code-repos.txt"
    try:
        response = s3.get_object(Bucket=s3_bucket, Key=se_key)
        print("s3 object: " + str(response))

    return { "ping": "pong"}
