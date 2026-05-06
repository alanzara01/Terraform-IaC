output "wordpress_url" {
  description = "URL to access WordPress"
  value       = "http://${aws_instance.wordpress.public_ip}"
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.wordpress.id
}

output "public_ip" {
  description = "Public IP of the WordPress instance"
  value       = aws_instance.wordpress.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i deployer-key.pem ec2-user@${aws_instance.wordpress.public_ip}"
}
