locals {
  resource_name = trimsuffix(substr("${local.prefix}-logs", 0, 32), "-")
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = local.resource_name
  description = "Security group for ALB"
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

resource "aws_lb" "web" {
  name            = local.resource_name
  subnets         = local.public_subnets
  security_groups = [module.alb_sg.security_group_id]
  idle_timeout    = 400

  access_logs {
    bucket  = module.s3_bucket.bucket_id
    prefix  = local.resource_name
    enabled = true
  }

  tags = merge(
    {
      Name = local.resource_name
    },
    local.common_tags
  )
}
