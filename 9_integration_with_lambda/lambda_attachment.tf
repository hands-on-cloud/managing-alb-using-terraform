locals {
  tg_arn = data.terraform_remote_state.alb.outputs.lambda_tg
}

data "aws_lambda_function" "existing" {
  function_name = "RandomPasswordGen"
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = local.tg_arn
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = local.tg_arn
  target_id        = data.aws_lambda_function.existing.arn
  depends_on       = [aws_lambda_permission.with_lb]
}