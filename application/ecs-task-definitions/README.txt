ECS TASK DEFINITION FILES

These JSON files document the Fargate container configuration used for the assignment.
Before registering a new revision, replace:
1. REPLACE_WITH_ACTUAL_ECS_TASK_EXECUTION_ROLE_ARN with the execution role ARN shown in ECS.
2. REPLACE_WITH_ALB_DNS_NAME with the ALB DNS name (terraform output alb_url).

The ECR image URIs and container ports match the deployed application:
- Backend: port 8000
- Frontend: port 3000
