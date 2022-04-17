# ------------ Create AWS ALB Security Group -----------

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-alb-sg"
  description = "Security group for ALB (HTTP and HTTPS ports are opened)"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]
}

# ------------ Create AWS ALB -----------

resource "aws_lb" "web" {
  name            = "${local.prefix}-alb"
  subnets         = local.public_subnets
  security_groups = [module.alb_sg.security_group_id]
  idle_timeout    = 400

  tags = merge(
    {
      Name = "${local.prefix}-alb"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group -----------

resource "aws_lb_target_group" "web" {
  name     = "${local.prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(
    {
      Name = "${local.prefix}-tg"
    },
    local.common_tags
  )
}

# ----------- Create AWS ALB HTTP Listener ------------

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
