# Description
This component listens to all SNS topics of the platform and puts every SNS message into `sns_log` table.

The table items must have following attrubutes:
```json
{
  "interaction_id": "PK, String; interaction_id taken from the SNS message",
  "message_timestamp": "SK, String (ISO-8601); when the message was posted to the topic",
  "topic_name": "String; name of the SNS topic where the message was posted",
  "message": "Map; unmodified message object"
}
```
