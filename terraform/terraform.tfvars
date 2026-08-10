region             = "eu-south-1"

project_name       = "pulse-ci"
environment        = "production"

vpc_cidr           = "10.0.0.0/16"

public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
private_subnet_b_cidr = "10.0.3.0/24"

instance_type      = "t3.micro"

ami_id             = "ami-xxxxxxxx"

ssh_allowed_ip = "38.137.18.254/32"

db_username = "pulseci"