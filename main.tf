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
    Name = "VPC Peering between main amd default"
  }
}