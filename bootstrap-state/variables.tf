variable "aws_region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_prefix" {
  description = "Prefix of the state bucket. The AWS account ID is appended to keep the name globally unique."
  type        = string
  default     = "vishnu-terraform-state"
}
