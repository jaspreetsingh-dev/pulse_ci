resource "aws_cloudwatch_log_group" "pulse_ci" {
  name              = "/pulse-ci/application"
  retention_in_days = 7
}