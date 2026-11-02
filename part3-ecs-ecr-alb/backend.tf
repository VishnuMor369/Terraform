# Remote state in S3 (bucket is created by ../bootstrap-state).
# Backend blocks cannot use variables, so the bucket name is written here.
# Bucket name format: vishnu-terraform-state-<AWS_ACCOUNT_ID>
terraform {
  backend "s3" {
    bucket       = "vishnu-terraform-state-783722568360"
    key          = "terraform-assignment/part3/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
