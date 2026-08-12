variable "repo_url" {
  type = string
}

variable "container_port" {
  type = number
}

variable "target_group_arn" {
  type = string
}

variable "db_secret_arn" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "environment" {}