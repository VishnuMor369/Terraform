ECS TASK DEFINITION FILES

These JSON files document the Fargate container configuration used for the assignment.
Before registering a new revision, replace:
1. REPLACE_WITH_ACTUAL_ECS_TASK_EXECUTION_ROLE_ARN with the execution role ARN shown in ECS.
2. REPLACE_WITH_ECS_BACKEND_SERVICE_DISCOVERY_OR_ALB_URL with the final internal backend endpoint when Service Discovery or an internal ALB is configured.

The ECR image URIs and container ports match the deployed application:
- Backend: port 8000
- Frontend: port 3000
