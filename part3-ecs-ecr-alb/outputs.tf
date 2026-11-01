output "backend_ecr" {
  value = aws_ecr_repository.backend.repository_url
}

output "frontend_ecr" {
  value = aws_ecr_repository.frontend.repository_url
}

output "cluster" {
  value = aws_ecs_cluster.main.name
}

output "alb_url" {
  value = "http://${aws_lb.app.dns_name}"
}
