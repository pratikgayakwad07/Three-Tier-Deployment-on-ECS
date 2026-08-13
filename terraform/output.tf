output "alb_dns_name" {
  value = module.ALB.alb_dns_name

}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_name" {
  value = module.rds.db_name
}

output "cloudfront_url" {
  value = module.cloudfront.cloudfront_url
}