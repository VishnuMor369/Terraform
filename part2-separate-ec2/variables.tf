variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type. t3.micro is Free Tier eligible on new AWS accounts (t2.micro is not eligible there, which caused InvalidParameterCombination)."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair"
  type        = string
}
