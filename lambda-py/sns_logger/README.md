# Description
This component puts every SNS message into `sns_log` table.

The table items must have following attrubutes:
```json
{
  "interaction_id": "String, PK; interaction_id taken from the SNS message",
  "topic_name": "String, SK; name of the SNS topic where the message was posted",
  "message_timestamp": "String (ISO-8601); when the message was posted to the topic",
  "message": "Map; unmodified message object"
}
```
