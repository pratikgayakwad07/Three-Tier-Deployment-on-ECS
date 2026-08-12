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
module "mysql" {

  source = "terraform-aws-modules/rds/aws"
  version = "~> 6.9"

  identifier = "${var.environment}-mysql"
  engine = "mysql"
  engine_version = var.engine_version

  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name = var.db_name
  db_username = var.db_username
  port = 3306

  manage_master_user_password = true
  multi_az = false

  create_db_subnet_group = true
  subnet_ids = var.private_subnets
  vpc_security_group_ids = [ aws_security_group.rds_sg.id]

  performance_insights_enabled = false
  monitoring_interval = 0
  publicly_accessible = false
  skip_final_snapshot = false

}