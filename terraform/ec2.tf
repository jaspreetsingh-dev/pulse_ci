resource "aws_instance" "pulse_ci" {

  ami                    = var.ami_id
  instance_type          = var.instance_type

  subnet_id              = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "${var.project_name}-ec2"
  }
}