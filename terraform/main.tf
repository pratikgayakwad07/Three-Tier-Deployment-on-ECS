module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr       = var.public_subnet_cidr
  private_subnet_cidr       = var.private_subnet_cidr
  create_nat_gateway = var.create_nat_gateway
}


module "ALB" {
  source = "./modules/ALB"

  environment = var.environment

  vpc_id        = module.vpc.vpc_output
  public_subnets = module.vpc.public_subnets
  container_port = var.container_port
}


module "sg" {
  source = "./modules/sg"

  vpc_id    = module.vpc.vpc_output
  alb_sg_id = module.ALB.alb_sg_id
}


module "ecr" {
  source = "./modules/ecr"

  repository_name = var.repository_name
}


module "ecs" {
  source = "./modules/ecs"

  environment = var.environment
  repo_url         = module.ecr.repo_url
  container_port   = var.container_port
  target_group_arn = module.ALB.target_group_arn

  db_secret_arn = module.database.master_user_secret_arn
  db_host       = module.database.db_endpoint
  db_name       = module.database.db_name
}


module "RDS" {
  source = "./modules/RDS"

  environment = var.environment
  vpc_id            = module.vpc.vpc_output
  private_subnets = module.vpc.private_subnets
  backend_sg_id     = module.sg.sg_id

  db_name           = var.db_name
  db_username       = var.db_username
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
}


module "asg" {
  source = "./modules/asg"

  instance_type        = var.instance_type
  instance_profile_name = module.ecs.instance_profile_name
  backend_sg_id        = module.sg.sg_id
  ecs_cluster_name     = module.ecs.ecs_cluster_name

  private_subnets      = module.vpc.private_subnets

  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
}


module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}


module "cloudfront" {
  source = "./modules/cloudfront"

  alb_dns = module.ALB.alb_dns

  bucket_regional_domain_name = "${module.s3.bucket_name}.s3.${var.aws_region}.amazonaws.com"
}