# Launch template for Auto Scaling

resource "aws_launch_template" "web_app_launch_template" {
  name = "csye6225_asg_launch_template"

  image_id      = var.custom_ami_id
  instance_type = "t2.medium"

  key_name = var.key_pair

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo snap install aws-cli --classic
npm install @aws-sdk/client-secrets-manager
    sudo apt-get update -y
    sudo apt-get install -y jq amazon-cloudwatch-agent
# Retrieve the database password from AWS Secrets Manager
DB_PASSWORD=$(aws secretsmanager get-secret-value --region ${var.aws_region} --secret-id ${aws_secretsmanager_secret.db_secret.name} --query SecretString --output text | jq -r '.password')


    sudo rm -rf /opt/csye6225/.env
    touch /opt/csye6225/.env
    echo "DB_HOST=${aws_db_instance.csye6225_rds.address}" >> /opt/csye6225/.env
    echo "DB_PORT=5432" >> /opt/csye6225/.env
    echo "DB_USER=csye6225" >> /opt/csye6225/.env
    echo "DB_PASSWORD=$DB_PASSWORD" >> /opt/csye6225/.env
    echo "DB_NAME=csye6225" >> /opt/csye6225/.env

    echo "S3_BUCKET_NAME=${local.s3_bucket_name}" >> /opt/csye6225/.env


    echo "REGION=us-east-1" >> /opt/csye6225/.env
    
    echo "SNS_TOPIC_ARN=${aws_sns_topic.user_verification_topic.arn}" >> /opt/csye6225/.env

    sudo chown csye6225:csye6225 /opt/csye6225/.env
    sudo mkdir -p /var/log/csye6225_stdop.log
    sudo chown csye6225:csye6225 /var/log/csye6225_stdop.log

    sudo systemctl restart amazon-cloudwatch-agent

    sudo systemctl stop webapp.service
    sudo systemctl daemon-reload
    sudo systemctl start webapp.service
  EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_kms.arn
    }
  }


}