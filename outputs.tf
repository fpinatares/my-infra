/*output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}*/

output "elsatic_beanstalk_url" {
  description = "The Elastic Beanstalk URL"
  value = aws_elastic_beanstalk_environment.la-cabana-avicola-service-dev.endpoint_url
}
/*
output "aws_db_instance_point" {
  value = aws_db_instance.la-cabana-avicola-db-dev.endpoint
}*/