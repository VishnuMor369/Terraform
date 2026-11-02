terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "app" {
  name = "vishnu-terraform-single-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    backend_app_b64          = filebase64("${path.module}/../application/backend/app.py")
    backend_business_b64     = filebase64("${path.module}/../application/backend/business.py")
    backend_requirements_b64 = filebase64("${path.module}/../application/backend/requirements.txt")
    backend_template_b64     = filebase64("${path.module}/../application/backend/templates/index.html")
    frontend_app_b64         = filebase64("${path.module}/../application/frontend/app.js")
    frontend_package_b64     = filebase64("${path.module}/../application/frontend/package.json")
    frontend_view_b64        = filebase64("${path.module}/../application/frontend/views/index.ejs")
  })

  tags = {
    Name = "Vishnu-Terraform-Single-EC2"
  }
}
