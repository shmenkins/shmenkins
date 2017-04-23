# SNS Topic Message format
`interaction_id`: unique id generated when Shmenkins receives a request (push notification,...); this id is part of any other message that resulted from this request.
## build_scheduled
Signals to a builder that source code needs to be built.
```json
{
  "interaction_id": "String; interaction id",
  "url": "String; source code repo url"
}
```
## build_status_changed
Signal to a scheduler that buid status changed.
```json
{
  "interaction_id": "String; interaction id",
  "url": "String; source code repo url",
  "status": "String; new build status (started, finished,...)"
}
```
## artifact_outdated
Signals to a scheduler that a build for an artifact needs to be scheduled.
```json
{
  "interaction_id": "String; interaction id",
  "url": "String; source code repo url for the outdated artifact"
}
