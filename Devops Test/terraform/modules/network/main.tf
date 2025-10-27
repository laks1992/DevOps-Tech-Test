resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.project}-vpc-${var.env}" }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "${var.project}-public-${count.index}" }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
