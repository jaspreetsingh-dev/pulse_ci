resource "aws_secretsmanager_secret" "github_token" {
  name = "${var.project_name}/github-token"
  description = "GitHub token used by Pulse CI."
}

resource "aws_secretsmanager_secret" "flask_secret" {
  name = "${var.project_name}/flask-secret"
  description = "Flask secret key used by Pulse CI."
}