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
    },
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },


  ]

  egress_rules = ["all-all"]
}

# ------------ Create AWS ALB -----------

resource "aws_lb" "web" {
  name            = "${local.prefix}-alb"
  subnets         = local.public_subnets
  security_groups = [module.alb_sg.security_group_id]
  idle_timeout    = 400

  access_logs {
    bucket  = data.terraform_remote_state.alb_access_logging.outputs.access_log_s3_id
    prefix  = "${local.prefix}-logs"
    enabled = true
  }

  tags = merge(
    {
      Name = "${local.prefix}-alb"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group -----------

resource "aws_lb_target_group" "web" {
  name     = "${local.prefix}-web"
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
      Name = "${local.prefix}-web"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group ----------- ( used in path-based topic)

resource "aws_lb_target_group" "sample" {
  name     = "${local.prefix}-path"
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
      Name = "${local.prefix}-path"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group ----------- ( used in attach alb to autocaling group)

resource "aws_lb_target_group" "autoscale" {
  name     = "${local.prefix}-asg"
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
      Name = "${local.prefix}-asg"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group ----------- ( used in attach alb to multiple asg topic)

resource "aws_lb_target_group" "bluetg" {
  name     = "${local.prefix}-blue"
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
      Name = "${local.prefix}-blue"
    },
    local.common_tags
  )
}

resource "aws_lb_target_group" "greentg" {
  name     = "${local.prefix}-green"
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
      Name = "${local.prefix}-green"
    },
    local.common_tags
  )
}

# ---------- Create AWS ALB Target Group ----------- ( used in attach alb to lambda topic)

resource "aws_lb_target_group" "lambdatg" {
  name        = "${local.prefix}-lambda"
  target_type = "lambda"

  tags = merge(
    {
      Name = "${local.prefix}-lambda"
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
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_attach_asg_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 8000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.autoscale.arn
  }
}

resource "aws_lb_listener" "multi_asg" {
  load_balancer_arn = aws_lb.web.arn
  port              = 9000
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.bluetg.arn
        weight = 80
      }

      target_group {
        arn    = aws_lb_target_group.greentg.arn
        weight = 20
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.terraform_remote_state.alb_https_listener.outputs.cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener" "lambda" {
  load_balancer_arn = aws_lb.web.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambdatg.arn
  }
}


