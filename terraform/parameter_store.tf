resource "aws_ssm_parameter" "github_token" {

  name        = "/${var.project_name}/github-token"
  description = "GitHub Personal Access Token."
  type        = "SecureString"
  value       = "replace-me"

}

resource "aws_ssm_parameter" "flask_secret" {

  name        = "/${var.project_name}/flask-secret"
  description = "Flask application secret key."
  type        = "SecureString"
  value       = "replace-me"

}