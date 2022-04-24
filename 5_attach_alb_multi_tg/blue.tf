locals {
  blue_resource_name = trimsuffix(substr("${local.prefix}-blue", 0, 32), "-")
}

resource "aws_launch_configuration" "blue" {
  name_prefix = local.blue_resource_name

  image_id      = local.ec2_ami # ubuntu 20.04 AMI (HVM), SSD Volume Type
  instance_type = local.ec2_instance_type

  security_groups             = [module.instance_sg.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
apt update
apt -y install nginx
chkconfig nginx on
cat <<'END_HTML' >/var/www/html/index.nginx-debian.html 
<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: blue;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon Blue Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on Amazon EC2.</p> </div></body></html> 
END_HTML
service nginx start
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "blue" {
  name = local.blue_resource_name

  min_size         = local.min_instance
  desired_capacity = local.min_instance
  max_size         = local.max_instance

  health_check_type = "ELB"

  target_group_arns    = [aws_lb_target_group.blue.arn]
  launch_configuration = aws_launch_configuration.blue.name

  metrics_granularity = "1Minute"

  vpc_zone_identifier = local.public_subnets

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = local.blue_resource_name
    propagate_at_launch = true
  }

}

# ------- ALB Target Group --------

resource "aws_lb_target_group" "blue" {
  name     = local.blue_resource_name
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
      Name = local.blue_resource_name
    },
    local.common_tags
  )
}
