variable "instance_type" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "backend_sg_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}
