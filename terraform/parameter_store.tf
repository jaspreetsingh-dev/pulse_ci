resource "aws_ssm_parameter" "environment" {

  name        = "/${var.project_name}/environment"
  description = "Deployment environment for Pulse CI."
  type        = "String"
  value       = var.environment

}

resource "aws_ssm_parameter" "log_level" {

  name        = "/${var.project_name}/log-level"
  description = "Application logging level."
  type        = "String"
  value       = "INFO"

}