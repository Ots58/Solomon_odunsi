# Creating a Public Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.pro_vpc.id
  cidr_block = var.public_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = "prod-subnet-Public"
  }
  }

# Creating a second Public Subnet
resource "aws_subnet" "subnet-1a" {
  vpc_id     = aws_vpc.pro_vpc.id
  cidr_block = var.public_cidr2
  availability_zone = "us-west-2b"

  tags = {
    Name = "prod-subnet-Public2"
  }
  }  

#Creating a Private Subnet
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.pro_vpc.id
  cidr_block = var.private_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = "prod-subnet-Private"
  }
}

#Creating a second Private Subnet
resource "aws_subnet" "subnet-2a" {
  vpc_id     = aws_vpc.pro_vpc.id
  cidr_block = var.private_cidr2
  availability_zone = "us-west-2b"

  tags = {
    Name = "prod-subnet-Private2"
  }
}

# Creating the database Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name = "db_subnet_group"
  subnet_ids = [aws_subnet.subnet-2.id, aws_subnet.subnet-2a.id]
  tags = {
    Name = "Prod-aurora-db"
  }
}