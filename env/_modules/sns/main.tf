#create an sns topic for codepipeline notifications
resource "aws_sns_topic" "codepipeline" {
  name = "codepipeline-notifications"
}

#assign permissions to sns topic for codepipeline notifications
resource "aws_sns_topic_policy" "notification" {
  arn    = aws_sns_topic.codepipeline.arn
  policy = data.aws_iam_policy_document.notification.json
}
