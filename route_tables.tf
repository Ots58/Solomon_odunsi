# Creating an Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.pro_vpc.id

}

# Creating a route table for the public subnet
resource "aws_route_table" "pro_rt" {
  vpc_id = aws_vpc.pro_vpc.id

  route {
    cidr_block = var.cidr_blocks
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "pro_routetable"
  }
}


# Creating a route table for the Private subnets
resource "aws_route_table" "pro_rt2" {
  vpc_id = aws_vpc.pro_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "pro_routetable2"
  }
}


# Associating route-table with Public subnet1
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.pro_rt.id
  depends_on = [aws_route_table.pro_rt,aws_subnet.subnet-1]
}  

# Associating route-table with Public subnet2
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.pro_rt.id
  depends_on = [aws_route_table.pro_rt,aws_subnet.subnet-1a]
}  

# Associating route-table with Private subnet1
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.pro_rt2.id
  depends_on = [aws_route_table.pro_rt2,aws_subnet.subnet-2]
}  

# Associating route-table with Private subnet2
resource "aws_route_table_association" "b2" {
  subnet_id      = aws_subnet.subnet-2a.id
  route_table_id = aws_route_table.pro_rt2.id
  depends_on = [aws_route_table.pro_rt2,aws_subnet.subnet-2a]
}  
