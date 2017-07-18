import main
from mock import patch, ANY
from botocore.exceptions import ClientError

url = "https://github.com/foo/bar"
event = {u'Records': [{u'EventVersion': u'1.0',
                       u'EventSubscriptionArn': u'arn:aws:sns:us-west-2:000000000000:build_scheduled:00000000-0000-0000-0000-000000000000',
                       u'EventSource': u'aws:sns',
                       u'Sns': {u'SignatureVersion': u'1', u'Timestamp': u'2017-04-10T05:12:56.297Z',
                                u'Signature': u'xxx',
                                u'SigningCertUrl': u'xxx',
                                u'MessageId': u'0000000000000-0000-0000-000000000000',
                                u'Message': u'{"interaction_id":"123", "url": "https://github.com/foo/bar"}',
                                u'MessageAttributes': {
                                    u'AWS.SNS.MOBILE.MPNS.NotificationClass': {u'Type': u'String',
                                                                               u'Value': u'realtime'},
                                    u'AWS.SNS.MOBILE.WNS.Type': {u'Type': u'String', u'Value': u'wns/badge'},
                                    u'AWS.SNS.MOBILE.MPNS.Type': {u'Type': u'String', u'Value': u'token'}},
                                u'Type': u'Notification',
                                u'UnsubscribeUrl': u'xxx',
                                u'TopicArn': u'arn:aws:sns:us-west-2:000000000000:build_scheduled', u'Subject': None}}]}
url_hash = "d3514ad1d4daedf9cc2825225070b49ebc8db47fa5177951b2a5b9994597570c"


@patch("main.topic_build_status_changed")
@patch("main.cb")
def test_existing_project(cb, topic):
    """
    Tests that:
    - CB project updated
    - CB build started
    - notification published
    """
    main.account = "abc"

    main.handle(event)

    cb.update_project.assert_called_once_with(name=url_hash,
                                              description=url,
                                              source=ANY,
                                              artifacts=ANY,
                                              environment=ANY,
                                              serviceRole=ANY)

    cb.start_build.assert_called_once_with(projectName=url_hash)

    topic.publish.assert_called_once_with({"interaction_id": "123", "url": url, "status": "started"})

    cb.create_project.assert_not_called()


@patch("main.topic_build_status_changed")
@patch("main.cb")
def test_build_new_project(cb, topic):
    """
    Tests that:
    - CB project created
    - CB build started
    - notification published
    """

    main.account = "123"

    resource_not_found_error = ClientError({"Error": {"Code": "ResourceNotFoundException", "Message": "test"}}, "test")
    cb.update_project.side_effect = resource_not_found_error

    main.handle(event)

    cb.update_project.assert_called_once_with(name=url_hash,
                                              description=url,
                                              source=ANY,
                                              artifacts=ANY,
                                              environment=ANY,
                                              serviceRole=ANY)

    cb.create_project.assert_called_once_with(name=url_hash,
                                              description=url,
                                              source=ANY,
                                              artifacts=ANY,
                                              environment=ANY,
                                              serviceRole=ANY)

    cb.start_build.assert_called_once_with(projectName=url_hash)

    topic.publish.assert_called_once_with({"interaction_id": "123", "url": url, "status": "started"})


@patch("main.topic_build_status_changed")
@patch("main.cb")
def test_project_update_error(cb, topic):
    """
    Tests that:
    - notification published on CB project update error
    """

    main.account = "123"

    cb.update_project.side_effect = ValueError("test")

    main.handle(event)

    cb.update_project.assert_called_once_with(name=url_hash,
                                              description=url,
                                              source=ANY,
                                              artifacts=ANY,
                                              environment=ANY,
                                              serviceRole=ANY)

    cb.create_project.assert_not_called()
    cb.start_build.assert_not_called()

    topic.publish.assert_called_once_with({"interaction_id": "123", "url": url, "status": "failed"})


@patch("main.topic_build_status_changed")
@patch("main.cb")
def test_project_creation_error(cb, topic):
    """
    Tests that:
    - notification published on CB project creation error
    """

    main.account = "123"

    resource_not_found_error = ClientError({"Error": {"Code": "ResourceNotFoundException", "Message": "test"}}, "test")
    cb.update_project.side_effect = resource_not_found_error

    cb.create_project.side_effect = ValueError("test")

    main.handle(event)

    cb.update_project.assert_called_once_with(name=url_hash,
                                              description=url,
                                              source=ANY,
                                              artifacts=ANY,
                                              environment=ANY,
                                              serviceRole=ANY)

    cb.create_project.assert_called_once_with(name=url_hash,
                                              description=url,
                                              source=ANY,
                                              artifacts=ANY,
                                              environment=ANY,
                                              serviceRole=ANY)
    cb.start_build.assert_not_called()

    topic.publish.assert_called_once_with({"interaction_id": "123", "url": url, "status": "failed"})
