# Application Load Balancer
resource "aws_lb" "articlehub" {
  name               = "articlehub-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    "subnet-0d1eff3661af05bcf",
    "subnet-0a4b560aee3322797"
  ]

  tags = {
    Name = "ArticleHub-ALB"
  }
}

# Target Group for ArticleHub frontend
resource "aws_lb_target_group" "articlehub" {
  name     = "articlehub-tg"
  port     = 3000
  protocol = "HTTP"

  vpc_id = data.aws_vpc.default.id

  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "3000"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "ArticleHub-Target-Group"
  }
}

# Attach ArticleHub EC2 to the target group
resource "aws_lb_target_group_attachment" "articlehub" {
  target_group_arn = aws_lb_target_group.articlehub.arn
  target_id        = aws_instance.articlehub.id
  port             = 3000
}

# HTTP listener
resource "aws_lb_listener" "articlehub" {
  load_balancer_arn = aws_lb.articlehub.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.articlehub.arn
      }
    }
  }
}