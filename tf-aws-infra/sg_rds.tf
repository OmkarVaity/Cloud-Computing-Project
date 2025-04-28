resource "aws_security_group" "db_security_group" {
  name        = "db_security_group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Allow inbound traffic from Application Security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.application_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_security_group"
  }
}