output "alb_dns_name" {
  value = module.ALB.alb_dns_name
  
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_name" {
  value = module.database.db_name
}

output "db_username" {
  value = module.database.db_username
}

output "cloudfront_domain_name" {
  value = module.ALB.cloudfront_domain_name
}
