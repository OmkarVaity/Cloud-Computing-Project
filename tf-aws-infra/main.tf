provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_igw"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zone1


  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zone2

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidrs[2]
  availability_zone = var.availability_zone3

  tags = {
    Name = "public_subnet_3"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zone1

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zone2

  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidrs[2]
  availability_zone = var.availability_zone3

  tags = {
    Name = "private_subnet_3"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_subnet_3_association" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "private_route_table"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_3_association" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}







resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "secretsmanager_tf_policy"
  description = "Policy for accessing specific Secrets Manager and KMS resources"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Access to the specific Secrets Manager secret
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:DeleteSecret",
          "secretsmanager:CreateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:RestoreSecret"
        ]
        Resource = "*"
      }
  ] })

}




resource "aws_iam_policy" "sns_policy" {
  name        = "sns_tf_policy"
  description = "Policy for managing specific sns functions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:CreateTopic",
          "sns:Subscribe",
          "sns:ListSubscriptions",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "sns:DeleteTopic",
          "sns:SetTopicAttributes",
          "sns:GetTopicAttributes",
          "sns:ListTagsForResource",
          "sns:GetSubscriptionAttributes",
          "sns:Unsubscribe",
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "autoscaling_policy" {
  name        = "autoscaling_tf_policy"
  description = "Policy for managing specific autoscaling functions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:CreateLaunchConfiguration",
          "autoscaling:AttachLoadBalancerTargetGroups",
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:PutScalingPolicy",
          "autoscaling:DescribePolicies",
          "autoscaling:DeletePolicy",
          "autoscaling:DetachLoadBalancerTargetGroups",
          "autoscaling:DescribeLoadBalancerTargetGroups",
          "autoscaling:StartInstanceRefresh",
          "autoscaling:DescribeInstanceRefreshes"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "elasticloadbalancer_policy" {
  name        = "elasticloadbalancer_tf_policy"
  description = "Policy for managing specific elasticloadbalancer functions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeListenerAttributes",
          "elasticloadbalancing:DescribeTargetHealth"
        ]
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "cloudwatch_tf_policy"
  description = "Policy for managing specific cloudwatch functions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListTagsForResource",
          "cloudwatch:DeleteAlarms"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "route53_policy" {
  name        = "route53_tf_policy"
  description = "Policy for managing specific route53 functions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:CreateHostedZone",
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetChange",
          "route53:ListTagsForResource",
          "route53:DeleteHostedZone"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "kms_policy" {
  name        = "kms_tf_policy"
  description = "Policy for managing specific KMS keys"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:ListAliases",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:ReEncrypt*",
          "kms:ScheduleKeyDeletion",
          "kms:EnableKeyRotation",
          "kms:GetKeyRotationStatus",
          "kms:GetKeyPolicy",
          "kms:ListKeyPolicies",
          "kms:ListResourceTags",
          "kms:PutKeyPolicy",
          "kms:TagResource"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "rds_policy" {
  name        = "rds_tf_policy"
  description = "Policy for rds"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:DescribeDBInstances",
          "rds:CreateDBParameterGroup",
          "rds:DeleteDBParameterGroup",
          "rds:ModifyDBParameterGroup",
          "rds:DescribeDBParameterGroups",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:ModifyDBSubnetGroup",
          "rds:DescribeDBSubnetGroups",
          "rds:ListTagsForResource",
          "rds:DescribeDBParameters",
          "rds:AddTagsToResource"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_create_policy" {
  name        = "LambdaCreatePolicy"
  description = "Policy to allow Lambda function creation"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:GetPolicy",
          "lambda:InvokeFunction",
          "lambda:AddPermission",
          "lambda:ListVersionsByFunction",
          "lambda:GetFunction",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:UpdateFunctionConfiguration",
          "lambda:RemovePermission",
          "lambda:CreateFunction",
          "lambda:DeleteFunction"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "dev_user_lambda_create_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_create_policy.arn
  user       = var.aws_profile
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment3" {
  policy_arn = aws_iam_policy.rds_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_role_policy_attachment" "kms_policy_attachment3" {
  policy_arn = aws_iam_policy.kms_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_role_policy_attachment" "route53_policy_attachment3" {
  policy_arn = aws_iam_policy.route53_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment3" {
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_role_policy_attachment" "elasticloadbalancer_policy_attachment3" {
  policy_arn = aws_iam_policy.elasticloadbalancer_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_role_policy_attachment" "autoscaling_policy_attachment3" {
  policy_arn = aws_iam_policy.autoscaling_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


resource "aws_iam_role_policy_attachment" "sns_policy_attachment3" {
  policy_arn = aws_iam_policy.sns_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}



resource "aws_iam_role_policy_attachment" "secretsmanager_policy_attachment3" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}





# Create KMS Key for RDS with a 90-day rotation period
resource "aws_kms_key" "rds_kms" {
  description             = "KMS key for RDS database"
  deletion_window_in_days = 10
  enable_key_rotation     = true # Automatic key rotation enabled
  key_usage               = "ENCRYPT_DECRYPT"

  tags = {
    Name = "rds-kms-key"
  }
}

resource "aws_kms_key_policy" "rds_kms_policy" {
  key_id = aws_kms_key.rds_kms.key_id

  policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/demo"
      },
      "Action": [
        "kms:GetKeyPolicy",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:PutKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:EnableKey",
        "kms:DisableKey",
        "kms:ListResourceTags",
        "kms:ScheduleKeyDeletion",
        "kms:TagResource"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}

  POLICY
}



# KMS Key for S3
resource "aws_kms_key" "s3_kms" {
  description             = "KMS key for S3 buckets"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}






resource "random_password" "db_password" {
  length           = 16
  special          = false # Ensures only alphanumeric characters are used
  override_special = ""    # No special characters
}

resource "random_pet" "db_secret_name" {
  length = 4 # Adjust length for more complex names
}

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "database-password-${random_pet.db_secret_name.id}"
  kms_key_id  = aws_kms_key.secrets_kms.arn
  description = "Database password for web application"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}



# Create a custom KMS key
resource "aws_kms_key" "email_secrets_kms" {
  description             = "KMS key for encrypting email service credentials"
  deletion_window_in_days = 7
}

# Secrets Manager Secret for email credentials
resource "aws_secretsmanager_secret" "email_service_secret" {
  name        = "es${replace(replace(timestamp(), ":", ""), "-", "")}"
  kms_key_id  = aws_kms_key.email_secrets_kms.arn
  description = "Email service credentials for the Lambda function"
}

# Secret version to store the credentials
resource "aws_secretsmanager_secret_version" "email_service_secret_version" {
  secret_id = aws_secretsmanager_secret.email_service_secret.id
  secret_string = jsonencode({
    sendgrid_api_key = var.sendgrid_api_key
  })
}




# Define the policies in a locals block
locals {
  policies = {
    kms_policy                 = aws_iam_policy.kms_policy.arn
    route53_policy             = aws_iam_policy.route53_policy.arn
    cloudwatch_policy          = aws_iam_policy.cloudwatch_policy.arn
    elasticloadbalancer_policy = aws_iam_policy.elasticloadbalancer_policy.arn
    autoscaling_policy         = aws_iam_policy.autoscaling_policy.arn
    sns_policy                 = aws_iam_policy.sns_policy.arn
    secrets_manager_policy     = aws_iam_policy.secrets_manager_policy.arn
  }
}


# Attach policies to users
resource "aws_iam_user_policy_attachment" "user_policy_attachments" {
  for_each   = local.policies
  policy_arn = each.value
  user       = var.aws_profile # Ensure var.aws_profile is defined in variables.tf

}






resource "aws_kms_key" "ec2_kms" {
  description             = "KMS key for encrypting the EC2 instances"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "ec2_kms_key_policy",
    Statement = [
      {
        Sid    = "Enable root IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        Sid    = "Enable EC2 to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.lambda_execution_role.name}"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow Secrets Manager to Use KMS Key",
        Effect = "Allow",
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        },
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "CSYE6225 Cloud EC2 KMS Key"
  }
}


resource "aws_kms_key" "secrets_kms" {
  description             = "KMS key for encrypting the Secrets Manager"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "sm_kms_key_policy",
    Statement = [
      {
        Sid    = "Enable root IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/demo"
        },
        Action   = "kms:*",
        Resource = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:*"
      },
      {
        Sid    = "Allow Lambda to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.lambda_execution_role.arn
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow EC2 to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.lambda_execution_role.arn
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow Lambda to use the KMS key",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.lambda_execution_role.arn
        },
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "CSYE6225 Cloud Secrets Manager KMS Key"
  }
}
