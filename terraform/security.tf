resource "aws_security_group" "web" {

  name        = "${var.project_name}-web-sg"
  description = "Allows inbound web traffic and SSH access to the Pulse CI EC2 instance."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-web-security-group"
  }
}

