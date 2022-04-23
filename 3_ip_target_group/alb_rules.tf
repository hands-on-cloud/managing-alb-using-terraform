locals {
  listener_arn = data.terraform_remote_state.alb.outputs.listener_arn

}
resource "aws_lb_listener_rule" "rule1" {
  listener_arn = local.listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = local.alb_target_group_id_sample
  }
  condition {
    path_pattern {
      values = ["/ip/*"]
    }
  }
}