# Terraform AWS Deployment – Vishnu

This submission updates the existing AWS deployment project and provisions the AWS infrastructure with Terraform.

## Application
- Flask backend: port 8000
- Express frontend: port 3000
- Existing Dockerfiles and application source are retained under `application/`.

## Assignment mapping
### Part 1 – Single EC2
Terraform creates one EC2 instance and installs/runs Flask and Express as systemd services.

### Part 2 – Separate EC2
Terraform creates a VPC, public subnet, route table, two security groups and two EC2 instances. The frontend receives the backend private IP through Terraform.

### Part 3 – ECR + ECS + VPC + ALB
Terraform creates two ECR repositories, a VPC with two public subnets, ECS Fargate cluster/services, IAM execution role, target groups and an Application Load Balancer. The ALB routes `/api` to Flask and all other requests to Express.

## Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.5
- Docker for Part 3
- An existing EC2 key pair for Parts 1 and 2
- Appropriate AWS IAM permissions

## Part 1 commands
```bash
cd part1-single-ec2
terraform init
terraform fmt
terraform validate
terraform plan -var="key_name=YOUR_KEY_PAIR"
terraform apply -var="key_name=YOUR_KEY_PAIR"
terraform output
```

## Part 2 commands
```bash
cd part2-separate-ec2
terraform init
terraform fmt
terraform validate
terraform plan -var="key_name=YOUR_KEY_PAIR"
terraform apply -var="key_name=YOUR_KEY_PAIR"
terraform output
```

## Part 3 commands
First build and push the existing application images to ECR:
```bash
cd ..
./part3-ecs-ecr-alb/build-and-push.sh
cd part3-ecs-ecr-alb
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
```

The ECR repositories are created by Terraform, so if they do not exist yet, run `terraform apply` once for the ECR resources, then run the image build/push script, and run `terraform apply` again to deploy ECS tasks.

## Terraform state
The assignment asks for Terraform state management. `backend.tf.example` shows the S3 backend configuration. Create a unique S3 bucket, copy it to `backend.tf`, replace the placeholder bucket name, and run `terraform init` again before deployment.

## Documentation
The Word documentation file is `Terraform_Assignment_Documentation.docx`.

## Screenshots
The `screenshots/legacy/` directory contains screenshots reused from the previous AWS assignment. For the Terraform submission, add screenshots of:
1. `terraform init`
2. `terraform validate`
3. `terraform plan`
4. `terraform apply`
5. Terraform outputs
6. AWS EC2/ECS/ECR/VPC/ALB resources after deployment
7. Final frontend URL working
8. `/api` backend response or application output

Do not claim that a Terraform deployment was executed unless the screenshot shows the actual command/output.

## GitHub repository
Add your final GitHub repository URL to `GitHub-Link.txt`.


## Simple Terraform Code
The Terraform files are intentionally written in a simple beginner-friendly style similar to the reference examples:
provider -> variables -> resources -> outputs.
AWS credentials should be configured using AWS CLI/environment variables. Do not put access keys directly in Terraform files.
