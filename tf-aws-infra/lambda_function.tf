resource "aws_lambda_function" "user_verification_lambda" {
  function_name = "userverificationLambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "src/index.handler"
  runtime       = "nodejs18.x"
  timeout       = 60

  environment {
    variables = {
      DB_HOST                  = aws_db_instance.csye6225_rds.address
      DB_PORT                  = "5432"
      DB_USER                  = "csye6225"
      DB_PASSWORD              = "Welcome123"
      DB_NAME                  = "csye6225"
      SENDGRID_API_KEY         = var.sendgrid_api_key
      SENDGRID_DOMAIN          = "em9468.dev.vaityorg.me"
      EMAIL_SERVICE_SECRET_ARN = "${aws_secretsmanager_secret.email_service_secret.name}"
    }
  }

  filename = "serverless.zip" # Upload your Lambda code as a zip file

}

resource "aws_sns_topic_subscription" "user_verification_subscription" {
  topic_arn = aws_sns_topic.user_verification_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.user_verification_lambda.arn

}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowSNSToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_verification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_verification_topic.arn
}