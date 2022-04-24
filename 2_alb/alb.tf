# ------------ Create AWS ALB Security Group -----------

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = local.vpc_id

  egress_rules = ["all-all"]
}

# ------------ Create AWS ALB -----------

resource "aws_lb" "web" {
  name            = "${local.prefix}-alb"
  subnets         = local.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  tags = merge(
    {
      Name = "${local.prefix}-alb"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group -----------
#
#resource "aws_lb_target_group" "web" {
#  name     = "${local.prefix}-tg"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = local.vpc_id
#
#  health_check {
#    healthy_threshold   = 5
#    unhealthy_threshold = 2
#    timeout             = 5
#    interval            = 30
#  }
#
#  tags = merge(
#    {
#      Name = "${local.prefix}-tg"
#    },
#    local.common_tags
#  )
#}
#
#resource "aws_lb_target_group" "sample" {
#  name     = "${local.prefix}-web"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = local.vpc_id
#
#  health_check {
#    healthy_threshold   = 5
#    unhealthy_threshold = 2
#    timeout             = 5
#    interval            = 30
#  }
#
#  tags = merge(
#    {
#      Name = "${local.prefix}-web"
#    },
#    local.common_tags
#  )
#}
#
#resource "aws_lb_target_group" "autoscale" {
#  name     = "asg-tg"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = local.vpc_id
#
#  health_check {
#    healthy_threshold   = 5
#    unhealthy_threshold = 2
#    timeout             = 5
#    interval            = 30
#  }
#
#  tags = merge(
#    {
#      Name = "asg-tg"
#    },
#    local.common_tags
#  )
#}
#
#resource "aws_lb_target_group" "bluetg" {
#  name     = "blue-tg"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = local.vpc_id
#
#  health_check {
#    healthy_threshold   = 5
#    unhealthy_threshold = 2
#    timeout             = 5
#    interval            = 30
#  }
#
#  tags = merge(
#    {
#      Name = "blue-tg"
#    },
#    local.common_tags
#  )
#}
#
#resource "aws_lb_target_group" "greentg" {
#  name     = "green-tg"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = local.vpc_id
#
#  health_check {
#    healthy_threshold   = 5
#    unhealthy_threshold = 2
#    timeout             = 5
#    interval            = 30
#  }
#
#  tags = merge(
#    {
#      Name = "green-tg"
#    },
#    local.common_tags
#  )
#}
#
#resource "aws_lb_target_group" "lambdatg" {
#  name        = "lambda-tg"
#  target_type = "lambda"
#
#  tags = merge(
#    {
#      Name = "lambda-tg"
#    },
#    local.common_tags
#  )
#}
#
## ----------- Create AWS ALB HTTP Listener ------------
#
#resource "aws_lb_listener" "web_http" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 80
#  protocol          = "HTTP"
#  default_action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}
#
#resource "aws_lb_listener" "alb_attach_asg_http" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 8000
#  protocol          = "HTTP"
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.autoscale.arn
#  }
#}
#
#resource "aws_lb_listener" "multi_asg" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 9000
#  protocol          = "HTTP"
#
#  default_action {
#    type = "forward"
#
#    forward {
#      target_group {
#        arn    = aws_lb_target_group.bluetg.arn
#        weight = 80
#      }
#
#      target_group {
#        arn    = aws_lb_target_group.greentg.arn
#        weight = 20
#      }
#    }
#  }
#}
#
#resource "aws_lb_listener" "https" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 443
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = data.terraform_remote_state.alb_https_listener.outputs.cert_arn
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.web.arn
#  }
#}
#
#resource "aws_lb_listener" "lambda" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 5000
#  protocol          = "HTTP"
#
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.lambdatg.arn
#  }
#}


