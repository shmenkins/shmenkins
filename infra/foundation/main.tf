resource "aws_sns_topic" "build_scheduled" {
  name = "build_scheduled"
}

# when artifact's source code or dependency changes
resource "aws_sns_topic" "artifact_outdated" {
  name = "artifact_outdated"
}

# when build status changes
resource "aws_sns_topic" "build_status_changed" {
  name = "build_status_changed"
}
 
