variable "region" {
  default = "us-east-1"
  type    = string
  description = "AWS Region"
}

variable "service_name" {
  type    = string
  description = "Service Name"
}

variable "cluster_name" {
  type    = string
  description = "Cluster Name"
}

variable "vpc_id" {
  type    = string
  description = "VPC ID"
}

variable "private_subnets" {
  type    = list
  description = "Private Subnets"
}

variable "service_port" {
  type = number
}

variable "service_cpu" {
  type = number
  default = 1024
}

variable "service_memory" {}

variable "ssm_vpc_id" {}

variable "ssm_listener" {}

variable "ssm_private_subnet_1" {}

variable "ssm_private_subnet_2" {}

variable "ssm_private_subnet_3" {}

variable "ssm_alb" {
  type = string
  default = "alb"
  
}

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

variable "scale_type" {
  
}

variable "task_minimum" {
  
}

variable "task_maximum" {
  
}

### Auto scaling de CPU out

variable "scalin_out_threshold" {
  type        = number
  description = "CPU threshold percentage for scaling out"
  default     = 80
}

variable "scalin_out_adjustment" {
  type        = number
  description = "Number of tasks to add when scaling out"
  default     = 1
}

variable "scalin_out_comparison_operator" {
  type        = string
  description = "Comparison operator for scaling out"
  default     = "GreaterThanOrEqualToThreshold"
}

variable "scalin_out_statistic" {
  type        = string
  description = "Statistic to use for scaling (Average, Maximum, etc)"
  default     = "Average"
}

variable "scalin_out_period" {
  type        = number
  description = "Period in seconds over which to evaluate the alarm"
  default     = 60
}

variable "scalin_out_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate the alarm"
  default     = 3
}
 
 variable "scalin_out_cooldown" {
  type        = number
  description = "Cooldown period in seconds"
  default     = 60
}

### Auto scaling de CPU in

variable "scalin_in_threshold" {
  type        = number
  description = "CPU threshold percentage for scaling out"
  default     = 80
}

variable "scalin_in_adjustment" {
  type        = number
  description = "Number of tasks to add when scaling out"
  default     = 1
}

variable "scalin_in_comparison_operator" {
  type        = string
  description = "Comparison operator for scaling out"
  default     = "GreaterThanOrEqualToThreshold"
}

variable "scalin_in_statistic" {
  type        = string
  description = "Statistic to use for scaling (Average, Maximum, etc)"
  default     = "Average"
}

variable "scalin_in_period" {
  type        = number
  description = "Period in seconds over which to evaluate the alarm"
  default     = 60
}

variable "scalin_in_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate the alarm"
  default     = 3
}
 
 variable "scalin_in_cooldown" {
  type        = number
  description = "Cooldown period in seconds"
  default     = 60
}

### Tracking CPU

variable "scaling_tracking_cpu" {
  
}

### Tracking requests

variable "scalin_tracking_requests" {
  
}