#!/usr/bin/env bash
# Builds both Docker images and pushes them to the ECR repositories created by Terraform.
# ECR repo names are read from Terraform outputs so they always match main.tf.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/../application"
REGION="${AWS_REGION:-us-east-1}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

BACKEND_REPO="$(cd "$SCRIPT_DIR" && terraform output -raw backend_ecr)"   # <account>.dkr.ecr.<region>.amazonaws.com/vishnu-backend
FRONTEND_REPO="$(cd "$SCRIPT_DIR" && terraform output -raw frontend_ecr)" # <account>.dkr.ecr.<region>.amazonaws.com/vishnu-frontend
REGISTRY="${BACKEND_REPO%%/*}"

aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"

# Fargate runs linux/amd64 by default, so build for that platform (needed on Apple Silicon too)
docker build --platform linux/amd64 -t "$BACKEND_REPO:$IMAGE_TAG"  "$APP_DIR/backend"
docker build --platform linux/amd64 -t "$FRONTEND_REPO:$IMAGE_TAG" "$APP_DIR/frontend"

docker push "$BACKEND_REPO:$IMAGE_TAG"
docker push "$FRONTEND_REPO:$IMAGE_TAG"
echo "Pushed $BACKEND_REPO:$IMAGE_TAG and $FRONTEND_REPO:$IMAGE_TAG"
