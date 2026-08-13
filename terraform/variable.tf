variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}


variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}


variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}


variable "create_nat_gateway" {
  description = "Whether to create a NAT gateway"
  type        = bool
  default     = true
}


variable "container_port" {
  description = "Port on which the backend container listens"
  type        = number
  default     = 5003
}


variable "repository_name" {
  description = "ECR repository name"
  type        = string
}


variable "bucket_name" {
  description = "S3 bucket name for the frontend"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type for ECS"
  type        = string
}


variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
}


variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
}


variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
}


variable "db_name" {
  description = "RDS database name"
  type        = string
}


variable "db_username" {
  description = "RDS master username"
  type        = string
}


variable "engine_version" {
  description = "MySQL engine version"
  type        = string
}


variable "instance_class" {
  type = string
}


variable "allocated_storage" {
  description = "Initial RDS storage in GB"
  type        = number
}


variable "max_allocated_storage" {
  description = "Maximum RDS storage in GB"
  type        = number
}