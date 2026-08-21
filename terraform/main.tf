terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
# Use the existing default VPC
data "aws_vpc" "default" {
  id = "vpc-020bf096bdfbca3dc"
}

# Security Group for the Load Balancer
resource "aws_security_group" "alb" {
  name        = "articlehub-alb-sg"
  description = "Allow HTTP traffic to ArticleHub Load Balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ArticleHub-ALB-SG"
  }
}

# Security Group for ArticleHub EC2
resource "aws_security_group" "app" {
  name        = "articlehub-app-sg"
  description = "Security group for ArticleHub application server"
  vpc_id      = data.aws_vpc.default.id

  # SSH access for administration
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend traffic will later come from the Load Balancer
  ingress {
    description     = "Frontend from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Backend traffic from the Load Balancer if required
  ingress {
    description     = "Backend from ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ArticleHub-App-SG"
  }
}

resource "aws_instance" "articlehub" {
  ami                         = "ami-01a00762f46d584a1"
  instance_type               = var.instance_type
  subnet_id                   = "subnet-0d1eff3661af05bcf"
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true
  key_name                    = "key"

  tags = {
    Name = "ArticleHub-App"
  }
}