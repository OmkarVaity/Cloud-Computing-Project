resource "aws_sns_topic" "user_verification_topic" {
  name = "user-verification-topic"
}

output "sns_topic_arn" {
  value       = aws_sns_topic.user_verification_topic.arn
  description = "SNS topic ARN for user verification"
}