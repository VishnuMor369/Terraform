# Terraform AWS Deployment – Vishnu

Deploys a Flask backend (port 8000) and an Express frontend (port 3000) on AWS with Terraform in three ways.
GitHub: https://github.com/VishnuMor369/Terraform.git

## Folder structure
```
bootstrap-state/     creates the S3 bucket used for remote state (run once)
part1-single-ec2/    Flask + Express on ONE EC2 instance
part2-separate-ec2/  Flask and Express on TWO EC2 instances in a custom VPC
part3-ecs-ecr-alb/   Docker images in ECR, ECS Fargate services, VPC, ALB
application/         Flask (backend/) and Express (frontend/) source + Dockerfiles
screenshots/         terraform and AWS console screenshots
```
Each part contains `main.tf`, `variables.tf`, `outputs.tf` and `backend.tf`. Parts 1 and 2 also contain
the user-data templates (`*.tftpl`) that `main.tf` loads with `templatefile()` — these files must be
committed to Git (`git add .` – no `.gitignore` rule should exclude `*.tftpl`).

## Prerequisites
- Terraform >= 1.11, AWS CLI configured (`aws configure`), Docker (Part 3)
- An existing EC2 key pair in us-east-1 (required for Parts 1 and 2). Copy `terraform.tfvars.example` to `terraform.tfvars` and set `key_name`.
- Default instance type is `t3.micro` (Free Tier eligible on new accounts; `t2.micro` caused `InvalidParameterCombination`).

## Step 0 – Remote state (S3 backend)
`backend.tf` in every part stores state in S3 bucket `vishnu-terraform-state-<AWS_ACCOUNT_ID>`
(currently `710882444873`; change it in the three `backend.tf` files if your account ID is different).
Create the bucket once:
```bash
cd bootstrap-state
terraform init
terraform apply
terraform output state_bucket_name
```

## Part 1 – Single EC2
```bash
cd part1-single-ec2
terraform init
terraform validate
terraform plan
terraform apply
terraform output          # frontend_url = http://<ip>:3000 , backend_url = http://<ip>:8000
```
User-data (`user-data.sh.tftpl`) installs Python and Node.js and starts Flask and Express as systemd services.
Express uses `BACKEND_URL=http://127.0.0.1:8000/api`. Wait 2–3 minutes after apply for installation to finish.

## Part 2 – Separate EC2 instances
```bash
cd part2-separate-ec2
terraform init && terraform validate && terraform plan && terraform apply
terraform output
```
Creates VPC, public subnet, internet gateway, route table, two security groups and two instances.
The frontend gets the backend private IP through Terraform (`BACKEND_URL=http://<backend_private_ip>:8000/api`).
Both apps are open to the internet on their ports; the backend SG also allows 8000 from the frontend SG.

## Part 3 – ECR + ECS Fargate + VPC + ALB
The ECS services need images in ECR, so deploy in this order:
```bash
cd part3-ecs-ecr-alb
terraform init
terraform apply -target=aws_ecr_repository.backend -target=aws_ecr_repository.frontend   # 1. ECR repos
./build-and-push.sh                                                                         # 2. build + push images
terraform plan
terraform apply                                                                             # 3. VPC, ALB, ECS
terraform output                                                                            # alb_url
```
- ECR repository names (`vishnu-backend`, `vishnu-frontend`) come from variables; `build-and-push.sh` reads them from Terraform outputs, so names always match.
- ALB listener (port 80): `/api` and `/api/*` -> Flask target group, everything else -> Express target group.
- The frontend task sets `BACKEND_URL=http://<ALB DNS>/api`, so the Express container reaches Flask through the ALB.
- Open `http://<alb_dns_name>` (frontend) and `http://<alb_dns_name>/api` (backend). Targets take 1–2 minutes to become healthy.

## Clean up (avoid AWS charges)
Run `terraform destroy` in each part (Part 3 first deletes the ECR images automatically, `force_delete = true`).
Destroy `bootstrap-state` last, and only after the other parts are destroyed (empty the versioned bucket first).

## Documentation and screenshots

The final documentation is `Terraform_Assignment_Documentation.docx`. The supplied evidence verifies the S3 bootstrap and Part 3 end-to-end. Part 1 first-run Free Tier failure is documented honestly, and Part 2 source is included but is not claimed as successfully applied because no successful Part 2 verification screenshot is available in the final evidence set.
`Terraform_Assignment_Documentation.docx` explains every step. Screenshots go in `screenshots/`
(part1, part2, part3, state) and are inserted into the docx where marked.
