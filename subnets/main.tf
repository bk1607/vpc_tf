# to create a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "main"
  }
}

#to create subnets
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  for_each = var.subnets
  cidr_block = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.value["name"]
  }
}

# create route tables for each subnet
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id
  for_each = var.subnets
  sub_net_name = each.value["name"]
  route {

  }

  tags = {
    Name = sub_net_name-route_table
  }
}