variable "region" {}

variable "service_name" {}

variable "cluster_name" {}

variable "vpc_id" {}

variable "private_subnets" {}

variable "service_port" {}

variable "service_cpu" {}

variable "service_memory" {}

variable "ssm_vpc_id" {}

variable "ssm_listener" {}

variable "ssm_private_subnet_1" {}

variable "ssm_private_subnet_2" {}

variable "ssm_private_subnet_3" {}

variable "environment_variables" {
  type = list
}

variable "capabilities" {
  type = list
}

variable "service_healthcheck" {}

variable "service_launch_type" {
  
}

variable "service_task_count" {
  
}

variable "service_hosts" {
  
}