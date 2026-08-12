output "db_endpoint" {
  value = aws_db_instance.mysql.address
}

output "db_port" {
  value = aws_db_instance.mysql.port
}

output "db_name" {
  value = aws_db_instance.mysql.db_name
}

output "db_instance_id" {
  value = aws_db_instance.mysql.id
}

output "database_sg_id" {
  value = aws_security_group.database_sg.id
}

output "master_user_secret_arn" {
  value = aws_db_instance.mysql.master_user_secret[0].secret_arn
}