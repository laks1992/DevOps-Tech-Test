# DevOps Tech Test - Simple Guide

## Build and push Docker image to ECR
1. Login to AWS: `aws configure` (enter your keys and default region)
2. Create ECR repo (if not exists):
   `aws ecr create-repository --repository-name devops-test-app`
3. Build the image:
   `docker build -t devops-test-app:latest ./app`
4. Tag the image for ECR:
   `docker tag devops-test-app:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/devops-test-app:latest`
5. Get login and push:
   `aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com`
   `docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/devops-test-app:latest`

## Terraform deployment
1. Initialize terraform (this reads backend and downloads providers):
   `terraform init`
2. Plan changes:
   `terraform plan -out plan.tfplan`
3. Apply:
   `terraform apply "plan.tfplan"`

## Get outputs (to access the app)
`terraform output alb_dns`  -> Use this DNS in a browser (http://<alb_dns>/)
