variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)

}

variable "availability_zone1" {
  description = "value of availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone2" {
  description = "value of availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "availability_zone3" {
  description = "value of availability zone"
  type        = string
  default     = "us-east-1c"
}

variable "custom_ami_id" {
  description = "The ID of the custom AMI built with Packer"
  type        = string
}

# variable "vpc_id" {
#   description = "VPC ID where the EC2 instance will be launched"
#   type        = string
# }

# variable "subnet_id" {
#   description = "Subnet ID for the EC2 instance"
#   type        = string
# }

variable "key_pair" {
  description = "SSH Key pair for EC2 instance"
  type        = string
  default     = ""
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
  default     = 5432
}


variable "allocated_storage" {
  description = "Allocated storage for RDS"
  type        = number
  default     = 20
}
variable "db_engine" {
  description = "Database engine for RDS"
  type        = string
  default     = "postgres"
}

variable "db_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.medium"
}

variable "db_instance_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_password" {
  description = "Password for the RDS instance"
  default     = "Welcome123"
  type        = string
}

variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Make RDS publicly accessible"
  type        = bool
  default     = false
}

variable "db_parameter_group_family" {
  description = "Family for the RDS parameter group"
  type        = string
  default     = "postgres13"

}

variable "rds_subnet_group" {
  description = "Subnet group for RDS"
  type        = string
}

# variable "rds_subnet_ids" {
#   description = "List of private subnet IDs for RDS"
#   type        = list(string)
# }

variable "db_subnet_group_name" {
  description = "Name for the RDS subnet group"
  type        = string
  default     = "rds-subnet-group"

}

variable "domain_name" {
  description = "Root domain name for the Route 53 hosted zone"
  type        = string
}

variable "subdomain_env" {
  description = "Subdomain environment (dev or demo)"
  type        = string
}

variable "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
}

variable "sendgrid_api_key" {
  description = "SendGrid API key for sending verification emails"
  type        = string
  sensitive   = true
}

# variable "app_port" {
#   description = "Application port number"
#   type        = number
# }

# variable "s3_bucket_name" {
#   description = "Name of the S3 bucket for the application"
#   type        = string
# }