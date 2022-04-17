locals {
  alb_target_group_id = data.terraform_remote_state.alb.outputs.alb_target_group_id
}

# ------- Add EC2 IPs to ALB Target Group --------

resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.nginx)
  target_group_arn = local.alb_target_group_id
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}
