locals {
  remote_state_bucket_region     = "us-west-2"
  remote_state_bucket            = "hands-on-cloud-terraform-remote-state-s3"
  infrastructure_state_file      = "managing-alb-using-terraform-infrastructure.tfstate"
  alb_state_file                 = "managing-alb-using-terraform-alb.tfstate"
  alb_ip_target_group_state_file = "managing-alb-using-terraform-alb-ip-target-group.tfstate"

  prefix          = data.terraform_remote_state.infrastructure.outputs.prefix
  common_tags     = data.terraform_remote_state.infrastructure.outputs.common_tags
  vpc_id          = data.terraform_remote_state.infrastructure.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.infrastructure.outputs.public_subnets
  private_subnets = data.terraform_remote_state.infrastructure.outputs.private_subnets

  # Launch configuration
  ec2_ami           = data.aws_ami.ubuntu.id
  ec2_instance_type = "t2.small"
  min_instance      = 2
  max_instance      = 5
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.infrastructure_state_file
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.alb_state_file
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

module "instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-sg"
  description = "Security group for nginx web servers"
  vpc_id      = local.vpc_id

  egress_rules = ["all-all"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = local.alb_sg
    }
  ]
}
