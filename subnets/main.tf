# to create a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "main"
  }
}

#to create public subnets
resource "aws_subnet" "pub_sub" {
  vpc_id     = aws_vpc.main.id
  for_each = var.public_subnets
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.value["name"]
  }
}

#to create private subnets
resource "aws_subnet" "pri_sub" {
  vpc_id     = aws_vpc.main.id
  for_each = var.private_subnets
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.value["name"]
  }
}

# create route tables for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  for_each = var.public_subnets

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${each.value["name"]}-route_table"
  }
}

# create route tables for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  for_each = var.private_subnets

  route = []

  tags = {
    Name = "${each.value["name"]}-route_table"
  }
}

# associate route tables to respective public subnets
resource "aws_route_table_association" "public" {
  for_each = var.public_subnets
  subnet_id      = aws_subnet.pub_sub[each.key].id
  route_table_id = aws_route_table.public_route_table[each.key].id
}

# associate route tables to respective private subnets
resource "aws_route_table_association" "private" {
  for_each = var.private_subnets
  subnet_id      = aws_subnet.pri_sub[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id
}

# creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}