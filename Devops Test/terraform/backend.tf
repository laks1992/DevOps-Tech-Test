terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket-name"
    key            = "devops-test/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}
