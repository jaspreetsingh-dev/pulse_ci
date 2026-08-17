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

resource "aws_ssm_parameter" "db_host" {
  name        = "/${var.project_name}/db-host"
  description = "RDS endpoint for Pulse CI."
  type        = "String"
  value       = aws_db_instance.postgres.address
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/${var.project_name}/db-name"
  description = "Pulse CI database name."
  type        = "String"
  value       = var.db_name
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/${var.project_name}/db-user"
  description = "Pulse CI database username."
  type        = "String"
  value       = var.db_username
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/${var.project_name}/db-port"
  description = "PostgreSQL port."
  type        = "String"
  value       = "5432"
}