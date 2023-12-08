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

  route = []

  tags = {
    Name = "${each.value["name"]}-route_table"
  }
}

# associate route tables to respective subnets
resource "aws_route_table_association" "a" {
  for_each = var.subnets
  subnet_id      = lookup(aws_subnet.main, each.value["name"]["id"], null)
  route_table_id = lookup(aws_route_table.example, each.value["name"]["id"], null)
}