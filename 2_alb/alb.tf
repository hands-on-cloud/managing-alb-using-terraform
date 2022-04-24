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
