output "backend_ip" {
  value = aws_instance.backend.public_ip
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "frontend_url" {
  value = "http://${aws_instance.frontend.public_ip}:3000"
}

output "backend_url" {
  value = "http://${aws_instance.backend.public_ip}:8000"
}
