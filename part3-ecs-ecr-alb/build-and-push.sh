#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-us-east-1}"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"
docker build -t athena-backend:latest application/backend
docker build -t athena-frontend:latest application/frontend
docker tag athena-backend:latest "$REGISTRY/athena-backend:latest"
docker tag athena-frontend:latest "$REGISTRY/athena-frontend:latest"
aws ecr describe-repositories --repository-names athena-backend athena-frontend --region "$REGION" >/dev/null 2>&1 || true
docker push "$REGISTRY/athena-backend:latest"
docker push "$REGISTRY/athena-frontend:latest"
