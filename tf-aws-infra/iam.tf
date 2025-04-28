resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ec2_instance_role"
  }
}

resource "aws_iam_policy" "s3_cloudwatch_policy" {
  name        = "s3_cloudwatch_policy"
  description = "Policy to allow S3 access and necessary CloudWatch permissions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.application_bucket.arn}",
          "${aws_s3_bucket.application_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "route53_management_policy" {
  name        = "route53_management_policy"
  description = "Policy to allow Route 53 management"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "ec2_sns_publish_policy" {
  name        = "ec2_sns_publish_policy"
  description = "Policy to allow EC2 to publish messages to SNS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sns:Publish",
        Resource = aws_sns_topic.user_verification_topic.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_sns_publish_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.ec2_sns_publish_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_s3_cloudwatch_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.s3_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "route53_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.route53_management_policy.arn
}

resource "aws_iam_role_policy_attachment" "autoscaling_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn

}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_instance_role.name
}



