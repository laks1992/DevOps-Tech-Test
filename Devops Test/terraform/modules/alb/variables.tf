variable "project" {}
variable "env" {}
variable "public_subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "vpc_id" {}
