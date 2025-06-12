# Security Group for the ALB
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "my-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]
}

# Listener for ALB
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default response"
      status_code  = "200"
    }
  }
}

module "service" {

  source = "github.com/AlexandreBarretoRosa/ecs-service-module?ref=v1.1.0"

  region                      = var.region
  cluster_name                = var.cluster_name
  service_name                = var.service_name
  service_port                = var.service_port
  service_cpu                 = var.service_cpu
  service_memory              = var.service_memory
  service_listener            = aws_lb_listener.main.arn
  service_healthcheck         = var.service_healthcheck
  service_task_execution_role = aws_iam_role.main.arn
  service_hosts               = var.service_hosts
  service_launch_type         = var.service_launch_type
  service_task_count          = var.service_task_count
  environment_variables       = var.environment_variables
  capabilities                = var.capabilities
  container_image             = var.container_image



  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  efs_volumes = [
    {
      name = "efs_volume"
      efs_volume_configuration = {
        file_system_id  = aws_efs_file_system.main.id
        file_sutem_root = "/"
        mount_point     = "/mnt/efs"
        read_only       = false
      }
    }
  ]

  ##Autoscaling##

  scale_type   = var.scale_type
  task_minimum = var.task_minimum
  task_maximum = var.task_maximum



  ### Autoscaling de CPU

  scalin_out_threshold = var.scalin_out_threshold

  scalin_out_adjustment = var.scalin_out_adjustment

  scalin_out_comparison_operator = var.scalin_out_comparison_operator

  scalin_out_statistic = var.scalin_out_statistic

  scalin_out_period = var.scalin_out_period

  scalin_out_evaluation_periods = var.scalin_out_evaluation_periods

  scalin_out_cooldown = var.scalin_out_cooldown

  ### Trackin de CPU

  scaling_tracking_cpu = var.scaling_tracking_cpu

  alb_arn      = aws_lb.main.arn
  listener_arn = aws_lb_listener.main.arn


  ### Trackin de requests

  scalin_tracking_requests = var.scalin_tracking_requests

}