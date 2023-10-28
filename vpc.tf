#Creating a VPC

resource "aws_vpc" "pro_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}