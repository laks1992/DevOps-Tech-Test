terraform {
  backend "s3" {
    bucket         = "techtest-onov8"
    key            = "devops-test/terraform.tfstate"
    region         = "me-central-1"
    dynamodb_table = "techtest-onov8"
    encrypt        = true
  }
}
