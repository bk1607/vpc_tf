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

#attach nat gateway to the private subnets in their respective availability zones
#locals {
#  private_subnet_to_nat_gateway = {
#    for private_subnet_key, private_subnet_data in var.private_subnets :
#    private_subnet_key => aws_nat_gateway.nat_gateways[private_subnet_key].id
#  }
#}

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
#resource "aws_route_table" "private_route_table" {
#  vpc_id = aws_vpc.main.id
#  for_each = var.private_subnets
#
#  route  {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = local.private_subnet_to_nat_gateway[each.key]
#  }
#
#  tags = {
#    Name = "${each.value["name"]}-route_table"
#  }
#  depends_on = [aws_nat_gateway.nat_gateways]
#}

# associate route tables to respective public subnets
resource "aws_route_table_association" "public" {
  for_each = var.public_subnets
  subnet_id      = aws_subnet.pub_sub[each.key].id
  route_table_id = aws_route_table.public_route_table[each.key].id
}

## associate route tables to respective private subnets
#resource "aws_route_table_association" "private" {
#  for_each = var.private_subnets
#  subnet_id      = aws_subnet.pri_sub[each.key].id
#  route_table_id = aws_route_table.private_route_table[each.key].id
#}

# creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

#output block for nat gateway
output "ngw_ids" {
  value = [for nat_gateway in values(aws_nat_gateway.nat_gateways.tags["Az"]) : nat_gateway]

}