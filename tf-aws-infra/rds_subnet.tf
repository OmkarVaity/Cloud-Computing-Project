resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "csye6225-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id
  ]

  tags = {
    Name = "csye6225-rds-subnet-group"
  }
}
