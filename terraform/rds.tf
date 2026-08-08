resource "aws_db_instance" "postgres" {
    engine = "postgres"

    instance_class = var.db_instance_class

    username = var.db_username

    password = var.db_password

    allocated_storage = 20

    vpc_security_group_ids = [aws_security_group.db.id]

    db_subnet_group_name = aws_db_subnet_group.postgres.name
}

resource "aws_db_subnet_group" "postgres" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}