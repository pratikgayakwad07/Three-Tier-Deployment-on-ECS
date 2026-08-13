## Create security group for RDS
resource "aws_security_group" "rds_sg" {
  name   = "${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.backend_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "mysql-db-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "mysql" {

  engine         = "mysql"
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  multi_az = false

  storage_encrypted = true

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  tags = {
    Name = "mysql-rds"
  }
}