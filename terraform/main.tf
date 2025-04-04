module "service" {

  source = "/home/lillico1405/linuxtips/ecs-service-module"

  region                      = var.region
  cluster_name                = var.cluster_name
  service_name                = var.service_name
  service_port                = var.service_port
  service_cpu                 = var.service_cpu
  service_memory              = var.service_memory
  service_listener            = data.aws_ssm_parameter.listener.value
  service_healthcheck         = var.service_healthcheck
  service_task_execution_role = aws_iam_role.main.arn
  service_hosts               = var.service_hosts
  service_launch_type         = var.service_launch_type
  service_task_count          = var.service_task_count
  environment_variables       = var.environment_variables
  capabilities                = var.capabilities



  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  ##Autoscaling##

  scale_type   = var.scale_type
  task_minimum = var.task_minimum
  task_maximum = var.task_maximum

}

### Autoscaling de CPU

scalin_out_cpu_treshold  = var.scalin_out_cpu_treshold

scalin_out_adjustment = var.scalin_out_adjustment

scalin_out_comparison_operator = var.scalin_out_comparison_operator

scalin_out_statistic = var.scalin_out_statistic

scalin_out_period  = var.scalin_out_period

scalin_out_evaluation_periods = var.scalin_out_evaluation_periods

scalin_out_cooldown = var.scalin_out_cooldown

### Trackin de CPU

scaling_tracking_cpu = var.scaling_tracking_cpu

alb_arn = data.aws_ssm_parameter.alb_arn.value

### Trackin de requests

scalin_tracking_requests = var.scalin_tracking_requests
