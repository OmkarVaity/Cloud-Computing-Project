resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "rds-parameter-group"
  family = "postgres16"

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "custom_rds_parameter_group"
  }
}