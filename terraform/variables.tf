variable "region" {
    type = string
    description = "AWS region for deployment."
}

variable "project_name" {
    type = string
    description = "Project name."
    default = "pulse-ci"
}

variable "environment" {
    type = string
    description = "Deployment environment."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet."
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet."
}

variable "private_subnet_b_cidr" {
  type        = string
  description = "CIDR block for the second private subnet."
}

variable "instance_type" {
    type = string
    description = "EC2 instance type."
    default = "t3.micro"
}

variable "ami_id" {
    type = string
    description = "AMI used for the EC2 instance."
}

variable "ssh_allowed_ip" {
  description = "Public IP allowed to SSH into the EC2 instance."
  type        = string
}

variable "db_name" {
  type        = string
  description = "Name of the Pulse CI database."
  default     = "pulse_ci"
}

variable "db_username" {
  type        = string
  description = "Username for the Pulse CI database."
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t3.micro"
}