# to create a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = "main"
  }
}

# to create peering connection between default vpc and main vpc
resource "aws_vpc_peering_connection" "test_peering" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = data.aws_vpc.default.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between main and default"
  }
}

# to create subnet for main vpc
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Main-subnet-01"
  }
}

# to configure routes in route table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "172.31.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.test_peering.id
  }
  route {
    cidr_block = "172.31.0.0/16"
  }

  tags = merge(
    var.tags,
    { Name = "main_route_table" }
}