locals {
  ec2_ami           = data.aws_ami.ubuntu.id
  ec2_instance_type = "t2.small"
  min_instance      = 2
  max_instance      = 5
  sg_id             = data.terraform_remote_state.ip_tg.outputs.instance_sg_id
  asg_tg            = data.terraform_remote_state.alb.outputs.asg_tg
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

resource "aws_key_pair" "ec2" {
  key_name   = "albdemo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdsWbfUvr2EMAtF+HqEW+aSYAlnPST6AsX59SY2PAcDzM2ZP0ByNNmy0xL2Gpij+j/hqJbfwHZ6CDLQyXUV354BSJ1b+5G1Z6ZAeYE8J7hl+8QOSiyjrCJZ3vVXLMT4QZe441MKhR3wnuiM+21QelnV3L0UP9eHhLTra0r5oJ/kP5EYYDv5KlpQa0h9DYHIvyu+blDQe7/wkBBrXUjdtEsHAVu++0tjeiS4UlRFPP+eKd7LabVclhMLR/d7DOmzkFZE9ZL31nNUzAlssMtzq5R/OkEQGb1pYv5LOip/rY4bExJBQgqMjdaFZvsBjtrhjgP5v/wzA32GDN7I3sAe8YykRvS+VEIHNksKyFFbVBMJ5oXVj1o7yMIZmGSLEgmOpPdo91J9Xj7Q71A8xqllIk9OmZfWLlvcaAGeV4RuvOzsx53v+EQln8rs8VCcih/lYiZGfLTQAU9ejdpyh/okj6rX/8qu8/2Oz0D/EqkN1XUTzRkve92+NcDP5AGHk8sfWE= swezinlinn@Swes-MBP.lan"
}

resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id      = local.ec2_ami # ubuntu 20.04 AMI (HVM), SSD Volume Type
  instance_type = local.ec2_instance_type
  key_name      = aws_key_pair.ec2.id

  security_groups             = [local.sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
apt update
apt -y install nginx
chkconfig nginx on
service nginx start
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = "${local.prefix}-asg"

  min_size         = local.min_instance
  desired_capacity = local.min_instance
  max_size         = local.max_instance

  health_check_type = "ELB"

  target_group_arns    = [local.asg_tg]
  launch_configuration = aws_launch_configuration.web.name

  metrics_granularity = "1Minute"

  vpc_zone_identifier = local.public_subnets

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${local.prefix}-asg"
    propagate_at_launch = true
  }

}