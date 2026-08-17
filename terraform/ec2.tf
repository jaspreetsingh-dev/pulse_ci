resource "aws_instance" "pulse_ci" {

  ami                    = var.ami_id
  instance_type          = var.instance_type

  subnet_id              = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = templatefile("${path.module}/userdata.sh", {
    project_name   = var.project_name
    rds_secret_arn = aws_db_instance.postgres.master_user_secret[0].secret_arn
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.project_name}-ec2"
  }
}