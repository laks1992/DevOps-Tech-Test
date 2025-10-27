#!/bin/bash
set -e
if [ -z "$1" ]; then
  echo "Usage: ./build-and-push.sh <aws_account_id> [region]"
  exit 1
fi
AWS_ACCOUNT=$1
REGION=${2:-us-east-1}
REPO_NAME="devops-test-app"
docker build -t $REPO_NAME:latest ./app
docker tag $REPO_NAME:latest ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
aws ecr create-repository --repository-name $REPO_NAME || true
docker push ${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest
