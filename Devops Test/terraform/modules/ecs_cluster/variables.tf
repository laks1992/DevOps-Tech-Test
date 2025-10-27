variable "project" {}
variable "env" {}
variable "ami_id" {}
variable "instance_type" { default = "t3.medium" }
variable "asg_min" { default = 1 }
variable "asg_max" { default = 2 }
variable "asg_desired" { default = 1 }
variable "subnet_ids" { type = list(string) }
