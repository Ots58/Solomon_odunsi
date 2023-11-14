#Creating a VPC

resource "aws_vpc" "pro_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames=true
  enable_dns_support = true
  tags = {
    Name = "production"
  }
}