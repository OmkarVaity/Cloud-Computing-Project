resource "aws_db_instance" "csye6225_rds" {
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  identifier             = var.db_instance_identifier
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.name
  storage_encrypted      = true # Enable encryption
  kms_key_id             = aws_kms_key.rds_kms.arn

  //final_snapshot_identifier = "csye6225-final-snapshot"

  skip_final_snapshot = true

  tags = {
    Name = var.db_instance_identifier
  }

}