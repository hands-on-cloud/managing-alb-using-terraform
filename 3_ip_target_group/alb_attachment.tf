locals {
  alb_target_group_id = data.terraform_remote_state.alb.outputs.alb_target_group_id
  sample_tg           = data.terraform_remote_state.alb.outputs.sample_tg
  alb_arn             = data.terraform_remote_state.alb.outputs.alb_arn

}

# ------- Add EC2 IPs to ALB Target Group --------

resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.nginx)
  target_group_arn = local.alb_target_group_id
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "sample" {
  count            = length(aws_instance.web)
  target_group_arn = local.alb_target_group_id_sample
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
