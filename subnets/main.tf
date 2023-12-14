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


# to create elastic ip
resource "aws_eip" "nat_eip" {
  for_each = var.public_subnets
  domain   = "vpc"

  tags = {
    Name = "${each.value["name"]}-eip"
  }
}


# to create nat gateway
resource "aws_nat_gateway" "nat_gateways" {
  for_each = var.public_subnets
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.pub_sub[each.key].id

  tags = {
    Name = "${each.value["az"]}-nat"
    Az   = "${each.value["az"]}"
  }
  depends_on = [aws_subnet.pub_sub]

}

#local variable to use in nat gateway resource and for storing nat id based on availability zones
locals {
  ngw_id = {
    for subnet_key, nat_gateway_data in aws_nat_gateway.nat_gateways :
    nat_gateway_data.tags.Az => nat_gateway_data.id
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

  route {
    cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }

  tags = {
    Name = "${each.value["name"]}-route_table"
  }
}

# create route tables for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  for_each = var.private_subnets

  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = local.ngw_id[each.value["az"]]
  }

  route {
    cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }

  tags = {
    Name = "${each.value["name"]}-route_table"
  }
  depends_on = [aws_nat_gateway.nat_gateways]
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

# value of default vpc
data "aws_vpc" "default"{
  default = true
}

#peering connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between main and default"
  }
}

##output block for nat gateway
#output "ngw_ids_by_az" {
#  value = {
#    for subnet_key, nat_gateway_data in aws_nat_gateway.nat_gateways :
#    nat_gateway_data.tags.Az => nat_gateway_data.id
#  }
#}