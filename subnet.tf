# Creating a Public Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.pro_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "prod-subnet-Public"
  }
  }

#Creating a Private Subnet
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.pro_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "prod-subnet-Private"
  }
}

 