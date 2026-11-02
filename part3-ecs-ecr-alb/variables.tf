variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "image_tag" {
  description = "Docker image tag to deploy from ECR"
  type        = string
  default     = "latest"
}

variable "backend_repo_name" {
  description = "ECR repository name for the Flask backend (build-and-push.sh uses the same name)"
  type        = string
  default     = "vishnu-backend"
}

variable "frontend_repo_name" {
  description = "ECR repository name for the Express frontend (build-and-push.sh uses the same name)"
  type        = string
  default     = "vishnu-frontend"
}
