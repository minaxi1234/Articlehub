# Security Group for ArticleHub RDS
resource "aws_security_group" "rds" {
  name        = "articlehub-rds-sg"
  description = "Allow PostgreSQL access from ArticleHub EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "PostgreSQL from ArticleHub EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ArticleHub-RDS-SG"
  }
}

# RDS subnet group using two Availability Zones
resource "aws_db_subnet_group" "articlehub" {
  name = "articlehub-db-subnet-group"

  subnet_ids = [
    "subnet-0d1eff3661af05bcf",
    "subnet-0a4b560aee3322797"
  ]

  tags = {
    Name = "ArticleHub-RDS-Subnet-Group"
  }
}

# PostgreSQL database
resource "aws_db_instance" "articlehub" {
  identifier        = "articlehub-postgres"
  engine            = "postgres"
  engine_version    = "17"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "my_db"
  username = "articlehub_user"
  password = "articlehub_pass_2026"

  db_subnet_group_name   = aws_db_subnet_group.articlehub.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "ArticleHub-PostgreSQL"
  }
}