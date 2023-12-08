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