resource "aws_db_instance" "postgres" {

  engine = "postgres"

  instance_class = var.db_instance_class

  db_name = var.db_name

  username = var.db_username

  manage_master_user_password = true

  allocated_storage = 20

  storage_encrypted = true

  port = 5432

  publicly_accessible = false

  vpc_security_group_ids = [
    aws_security_group.db.id
  ]

  db_subnet_group_name = aws_db_subnet_group.postgres.name

  backup_retention_period = 0

  deletion_protection = false
}

resource "aws_db_subnet_group" "postgres" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}