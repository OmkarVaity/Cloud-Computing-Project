# Security Group for EC2 Application
resource "aws_security_group" "application_sg" {
  name        = "application_sg"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Allow SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  # Allow HTTP traffic on port 80
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic on port 443
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow Application Port"
    from_port   = var.application_port
    to_port     = var.application_port
    protocol    = "tcp"
    //  cidr_blocks = ["0.0.0.0/0"] # Restrict to localhost only for the database
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application_security_group"
  }
}

# EC2 Instance to host the application
# resource "aws_instance" "app_instance" {
#   ami                         = var.custom_ami_id
#   instance_type               = "t2.micro"
#   key_name                    = var.key_pair
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

#   # Security group for the instance
#   vpc_security_group_ids = [aws_security_group.application_sg.id]
#   subnet_id              = aws_subnet.public_subnet_1.id

#   # Root EBS volume configuration
#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   # Do not prevent termination
#   disable_api_termination = false

#   user_data = <<-EOF
#     #!/bin/bash

#     sudo apt-get update -y
#     sudo apt-get install -y jq amazon-cloudwatch-agent

#     sudo rm -rf /opt/csye6225/.env
#     touch /opt/csye6225/.env
#     echo "DB_HOST=${aws_db_instance.csye6225_rds.address}" >> /opt/csye6225/.env
#     echo "DB_PORT=5432" >> /opt/csye6225/.env
#     echo "DB_USER=csye6225" >> /opt/csye6225/.env
#     echo "DB_PASSWORD=Welcome123" >> /opt/csye6225/.env
#     echo "DB_NAME=csye6225" >> /opt/csye6225/.env

#     echo "S3_BUCKET_NAME=${local.s3_bucket_name}" >> /opt/csye6225/.env


#     echo "REGION=us-east-1" >> /opt/csye6225/.env


#     sudo chown csye6225:csye6225 /opt/csye6225/.env
#     sudo mkdir -p /var/log/csye6225_stdop.log
#     sudo chown csye6225:csye6225 /var/log/csye6225_stdop.log

#     sudo systemctl restart amazon-cloudwatch-agent

#     sudo systemctl stop webapp.service
#     sudo systemctl daemon-reload
#     sudo systemctl start webapp.service
#   EOF


#   tags = {
#     Name = "application-ec2-instance"
#   }

#   depends_on = [aws_db_instance.csye6225_rds]
# }
