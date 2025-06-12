
# EFS File System
resource "aws_efs_file_system" "main" {
  creation_token   = format("$s-efs", var.service_name)
  performance_mode = "generalPurpose"

  tags = {
    Name = "efs"
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

# Mount Target for EFS
resource "aws_efs_mount_target" "mount_1a" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = data.aws_ssm_paremeter.private_subnet_1.value
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "mount_1b" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = data.aws_ssm_paremeter.private_subnet_1.value
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "mount_1c" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = data.aws_ssm_paremeter.private_subnet_1.value
  security_groups = [aws_security_group.efs.id]
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Security group for EFS mount targets"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-security-group"
  }
}

# EFS Access Point
resource "aws_efs_access_point" "efs" {
  file_system_id = aws_efs_file_system.main.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/efs"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name = "efs-access-point"
  }
}