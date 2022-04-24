locals {
  ec2_ami               = data.aws_ami.ubuntu.id
  ec2_instance_type     = "t2.small"
  alb_security_group_id = data.terraform_remote_state.alb.outputs.alb_security_group_id
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

  name        = "${local.prefix}-nginx-sg"
  description = "Security group for nginx web servers"
  vpc_id      = local.vpc_id

  egress_rules = ["all-all"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = local.alb_security_group_id
    }
  ]
}

resource "aws_instance" "nginx" {
  count                       = length(local.private_subnets)
  ami                         = local.ec2_ami
  instance_type               = local.ec2_instance_type
  vpc_security_group_ids      = [module.instance_sg.security_group_id]
  subnet_id                   = local.private_subnets[count.index]
  associate_public_ip_address = true

  user_data = <<EOT
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
  EOT

  tags = merge(
    {
      Name = "${local.prefix}-nginx-${count.index + 1}"
    },
    local.common_tags
  )
}
