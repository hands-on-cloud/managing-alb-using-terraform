locals {
  green_tg = data.terraform_remote_state.alb.outputs.green_tg
}


resource "aws_launch_configuration" "green" {
  name_prefix = "green-"

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
cat <<'END_HTML' >/var/www/html/index.nginx-debian.html 
<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: green;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon Blue Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on Amazon EC2.</p> </div></body></html> 
END_HTML
service nginx start
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "green" {
  name = "${local.prefix}-green"

  min_size         = local.min_instance
  desired_capacity = local.min_instance
  max_size         = local.max_instance

  health_check_type = "ELB"

  target_group_arns    = [local.green_tg]
  launch_configuration = aws_launch_configuration.green.name

  metrics_granularity = "1Minute"

  vpc_zone_identifier = local.public_subnets

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${local.prefix}-green"
    propagate_at_launch = true
  }

}