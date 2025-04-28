// source "amazon-ebs" "ubuntu_ami" {
//   // region        = var.aws_region
//   ami_name      = "custom-ubuntu-ami-{{timestamp}}"
//   ami           = var.source_ami
//   ssh_username  = "ubuntu"
//   instance_type = "t2.micro"
//   ami_users     = ["954976305817", "841162686161"]
// }

// source "amazon-ebs" "ubuntu_ami" {
//   //  region        = var.region
//   source_ami    = var.source_ami                        //"ami-0dba2cb6798deb6d8"
//   instance_type = var.instance_type                     //"t2.medium"
//   ssh_username  = "ubuntu"
//   ami_name      = "custom-ubuntu-ami-{{timestamp}}"
//   vpc_id        = var.vpc_id                            //"vpc-071c1ca095433c6e0"
//   subnet_id     = var.subnet_id                         //"subnet-0853482c4bdd804b6"
//   ami_users     = var.ami_users                         //["954976305817", "841162686161"]
// }

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where resources will be deployed"
}

variable "source_ami" {
  type = string
  //  default     = "ami-08cbf15038e1cb36a"
  default     = "ami-0866a3c8686eaeeba"
  description = "Source AMI to build the custom AMI"
}

variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Instance type for the AMI"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-071c1ca095433c6e0"
  description = "VPC ID where the AMI will be built"
}

variable "subnet_id" {
  type        = string
  default     = "subnet-0853482c4bdd804b6"
  description = "Subnet ID for instance creation"
}

variable "ami_users" {
  type        = list(string)
  default     = ["954976305817", "841162686161"]
  description = "AWS account IDs to share the AMI with"
}


source "amazon-ebs" "ubuntu_ami" {
  // region        = var.aws_region
  ami_name      = "custom-ubuntu-ami-{{timestamp}}"
  source_ami    = "${var.source_ami}"
  instance_type = "${var.instance_type}"
  vpc_id        = "${var.vpc_id}"
  subnet_id     = "${var.subnet_id}"
  ami_users     = "${var.ami_users}"
  ssh_username  = "ubuntu"
}

//   source_ami_filter {
//     filters = {
//       name                = "ubuntu/images/*ubuntu-24.04*"
//       root-device-type    = "ebs"
//       virtualization-type = "hvm"
//     }
//     most_recent = true
//     owners      = ["099720109477"]
//   }



//   ami_users = ["954976305817", "841162686161"]
// }

build {
  sources = ["source.amazon-ebs.ubuntu_ami"]

  provisioner "file" {
    source      = "./webapp.zip"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "./webapp.service"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "./packer/scripts/cloudwatch-config.json"
    destination = "/tmp/cloudwatch-config.json"
  }

  provisioner "shell" {
    scripts = [
      "./packer/scripts/create_user.sh",
      "./packer/scripts/setup_dependencies.sh",
      "./packer/scripts/set_app_config.sh",
      "./packer/scripts/systemd_file.sh",
      "./packer/scripts/install_cloudwatch_agent.sh",
    ]
  }
}
