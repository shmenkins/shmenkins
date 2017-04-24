from __future__ import print_function
import boto3
import time
import shmenkins
import json
import requests
import config


def test_when_push_notification_then_artifact_outdated_message_published():
    """ When a push notification received from github
        then a the repo url is published to 'artifact_outdated' topic """

    # send github push notification
    post_data = json.dumps(github_webhook_payload)
    response = requests.post(config.webhook_api_url, data=post_data, headers={"Content-Type": "application/json"})
    # check response
    assert response.status_code == 201
    interaction_id = response.headers.get("X-Shmenkins-InteractionId")
    assert len(interaction_id) == 36
    
    # let the lambda finish
    time.sleep(2)

    # check sns log for a message in "artifact_outdated" topic
    items = shmenkins.get_published_events(interaction_id)
    artifact_outdated_events = [x for x in items if x["topic_name"] == "artifact_outdated"]
    assert len(artifact_outdated_events) == 1


# payload is stored as a string in the event body
github_webhook_payload ={
  "ref": "refs/heads/master",
  "before": "5267c0c79a739cfc3ee69e892ade78871753fc8a",
  "after": "856c2c2e39a4ffadba2501df2c7dcf6b56b16543",
  "created": False,
  "deleted": False,
  "forced": False,
  "base_ref": None,
  "compare": "https://github.com/rzhilkibaev/cfgen/compare/5267c0c79a73...856c2c2e39a4",
  "commits": [
    {
      "id": "856c2c2e39a4ffadba2501df2c7dcf6b56b16543",
      "tree_id": "dfeb02523b7f7e275a0e8c84cee5c3a30df700ca",
      "distinct": True,
      "message": "Create delete-me",
      "timestamp": "2017-04-23T01:41:52-07:00",
      "url": "https://github.com/rzhilkibaev/cfgen/commit/856c2c2e39a4ffadba2501df2c7dcf6b56b16543",
      "author": {
        "name": "Renat",
        "email": "rzhilkibaev@users.noreply.github.com",
        "username": "rzhilkibaev"
      },
      "committer": {
        "name": "GitHub",
        "email": "noreply@github.com",
        "username": "web-flow"
      },
      "added": [
        "delete-me"
      ],
      "removed": [

      ],
      "modified": [

      ]
    }
  ],
  "head_commit": {
    "id": "856c2c2e39a4ffadba2501df2c7dcf6b56b16543",
    "tree_id": "dfeb02523b7f7e275a0e8c84cee5c3a30df700ca",
    "distinct": True,
    "message": "Create delete-me",
    "timestamp": "2017-04-23T01:41:52-07:00",
    "url": "https://github.com/rzhilkibaev/cfgen/commit/856c2c2e39a4ffadba2501df2c7dcf6b56b16543",
    "author": {
      "name": "Renat",
      "email": "rzhilkibaev@users.noreply.github.com",
      "username": "rzhilkibaev"
    },
    "committer": {
      "name": "GitHub",
      "email": "noreply@github.com",
      "username": "web-flow"
    },
    "added": [
      "delete-me"
    ],
    "removed": [

    ],
    "modified": [

    ]
  },
  "repository": {
    "id": 72402842,
    "name": "cfgen",
    "full_name": "rzhilkibaev/cfgen",
    "owner": {
      "name": "rzhilkibaev",
      "email": "rzhilkibaev@users.noreply.github.com",
      "login": "rzhilkibaev",
      "id": 3160853,
      "avatar_url": "https://avatars1.githubusercontent.com/u/3160853?v=3",
      "gravatar_id": "",
      "url": "https://api.github.com/users/rzhilkibaev",
      "html_url": "https://github.com/rzhilkibaev",
      "followers_url": "https://api.github.com/users/rzhilkibaev/followers",
      "following_url": "https://api.github.com/users/rzhilkibaev/following{/other_user}",
      "gists_url": "https://api.github.com/users/rzhilkibaev/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/rzhilkibaev/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/rzhilkibaev/subscriptions",
      "organizations_url": "https://api.github.com/users/rzhilkibaev/orgs",
      "repos_url": "https://api.github.com/users/rzhilkibaev/repos",
      "events_url": "https://api.github.com/users/rzhilkibaev/events{/privacy}",
      "received_events_url": "https://api.github.com/users/rzhilkibaev/received_events",
      "type": "User",
      "site_admin": False
    },
    "private": False,
    "html_url": "https://github.com/rzhilkibaev/cfgen",
    "description": "Config for config",
    "fork": False,
    "url": "https://github.com/rzhilkibaev/cfgen",
    "forks_url": "https://api.github.com/repos/rzhilkibaev/cfgen/forks",
    "keys_url": "https://api.github.com/repos/rzhilkibaev/cfgen/keys{/key_id}",
    "collaborators_url": "https://api.github.com/repos/rzhilkibaev/cfgen/collaborators{/collaborator}",
    "teams_url": "https://api.github.com/repos/rzhilkibaev/cfgen/teams",
    "hooks_url": "https://api.github.com/repos/rzhilkibaev/cfgen/hooks",
    "issue_events_url": "https://api.github.com/repos/rzhilkibaev/cfgen/issues/events{/number}",
    "events_url": "https://api.github.com/repos/rzhilkibaev/cfgen/events",
    "assignees_url": "https://api.github.com/repos/rzhilkibaev/cfgen/assignees{/user}",
    "branches_url": "https://api.github.com/repos/rzhilkibaev/cfgen/branches{/branch}",
    "tags_url": "https://api.github.com/repos/rzhilkibaev/cfgen/tags",
    "blobs_url": "https://api.github.com/repos/rzhilkibaev/cfgen/git/blobs{/sha}",
    "git_tags_url": "https://api.github.com/repos/rzhilkibaev/cfgen/git/tags{/sha}",
    "git_refs_url": "https://api.github.com/repos/rzhilkibaev/cfgen/git/refs{/sha}",
    "trees_url": "https://api.github.com/repos/rzhilkibaev/cfgen/git/trees{/sha}",
    "statuses_url": "https://api.github.com/repos/rzhilkibaev/cfgen/statuses/{sha}",
    "languages_url": "https://api.github.com/repos/rzhilkibaev/cfgen/languages",
    "stargazers_url": "https://api.github.com/repos/rzhilkibaev/cfgen/stargazers",
    "contributors_url": "https://api.github.com/repos/rzhilkibaev/cfgen/contributors",
    "subscribers_url": "https://api.github.com/repos/rzhilkibaev/cfgen/subscribers",
    "subscription_url": "https://api.github.com/repos/rzhilkibaev/cfgen/subscription",
    "commits_url": "https://api.github.com/repos/rzhilkibaev/cfgen/commits{/sha}",
    "git_commits_url": "https://api.github.com/repos/rzhilkibaev/cfgen/git/commits{/sha}",
    "comments_url": "https://api.github.com/repos/rzhilkibaev/cfgen/comments{/number}",
    "issue_comment_url": "https://api.github.com/repos/rzhilkibaev/cfgen/issues/comments{/number}",
    "contents_url": "https://api.github.com/repos/rzhilkibaev/cfgen/contents/{+path}",
    "compare_url": "https://api.github.com/repos/rzhilkibaev/cfgen/compare/{base}...{head}",
    "merges_url": "https://api.github.com/repos/rzhilkibaev/cfgen/merges",
    "archive_url": "https://api.github.com/repos/rzhilkibaev/cfgen/{archive_format}{/ref}",
    "downloads_url": "https://api.github.com/repos/rzhilkibaev/cfgen/downloads",
    "issues_url": "https://api.github.com/repos/rzhilkibaev/cfgen/issues{/number}",
    "pulls_url": "https://api.github.com/repos/rzhilkibaev/cfgen/pulls{/number}",
    "milestones_url": "https://api.github.com/repos/rzhilkibaev/cfgen/milestones{/number}",
    "notifications_url": "https://api.github.com/repos/rzhilkibaev/cfgen/notifications{?since,all,participating}",
    "labels_url": "https://api.github.com/repos/rzhilkibaev/cfgen/labels{/name}",
    "releases_url": "https://api.github.com/repos/rzhilkibaev/cfgen/releases{/id}",
    "deployments_url": "https://api.github.com/repos/rzhilkibaev/cfgen/deployments",
    "created_at": 1477890271,
    "updated_at": "2016-11-13T03:06:56Z",
    "pushed_at": 1492936912,
    "git_url": "git://github.com/rzhilkibaev/cfgen.git",
    "ssh_url": "git@github.com:rzhilkibaev/cfgen.git",
    "clone_url": "https://github.com/rzhilkibaev/cfgen.git",
    "svn_url": "https://github.com/rzhilkibaev/cfgen",
    "homepage": None,
    "size": 34,
    "stargazers_count": 0,
    "watchers_count": 0,
    "language": "Python",
    "has_issues": True,
    "has_projects": True,
    "has_downloads": True,
    "has_wiki": True,
    "has_pages": False,
    "forks_count": 0,
    "mirror_url": None,
    "open_issues_count": 0,
    "forks": 0,
    "open_issues": 0,
    "watchers": 0,
    "default_branch": "master",
    "stargazers": 0,
    "master_branch": "master"
  },
  "pusher": {
    "name": "rzhilkibaev",
    "email": "rzhilkibaev@users.noreply.github.com"
  },
  "sender": {
    "login": "rzhilkibaev",
    "id": 3160853,
    "avatar_url": "https://avatars1.githubusercontent.com/u/3160853?v=3",
    "gravatar_id": "",
    "url": "https://api.github.com/users/rzhilkibaev",
    "html_url": "https://github.com/rzhilkibaev",
    "followers_url": "https://api.github.com/users/rzhilkibaev/followers",
    "following_url": "https://api.github.com/users/rzhilkibaev/following{/other_user}",
    "gists_url": "https://api.github.com/users/rzhilkibaev/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/rzhilkibaev/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/rzhilkibaev/subscriptions",
    "organizations_url": "https://api.github.com/users/rzhilkibaev/orgs",
    "repos_url": "https://api.github.com/users/rzhilkibaev/repos",
    "events_url": "https://api.github.com/users/rzhilkibaev/events{/privacy}",
    "received_events_url": "https://api.github.com/users/rzhilkibaev/received_events",
    "type": "User",
    "site_admin": False
  }
}

