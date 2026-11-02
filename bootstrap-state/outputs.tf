output "state_bucket_name" {
  description = "Use this bucket name in backend.tf of every part"
  value       = aws_s3_bucket.state.id
}
