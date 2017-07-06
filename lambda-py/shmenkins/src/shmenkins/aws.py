import boto3
import json


class Aws:
    def __init__(self) -> None:
        self.__region = boto3.session.Session().region_name
        self.__account = boto3.client("sts").get_caller_identity().get("Account")
        self.__sns = boto3.resource("sns")

    def get_topic(self, topic_name: str) -> Topic:
        return Topic(self.__sns.Topic("arn:aws:sns:" + self.__region + ":" + self.__account + ":" + topic_name))


class Topic:
    def __init__(self, topic) -> None:
        self.__topic = topic

    def publish(self, obj: dict) -> None:
        """ Publish a message, obj must be dict and is converted to json """
        self.__topic.publish(Message=json.dumps(obj))
