data "aws_vpc" "default" {
  default = true
}
data "aws_vpc" "main"{
  tags = {
    Name = "main"
  }
  depends_on = [aws_vpc.main]
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  depends_on = [aws_subnet.pub_sub,aws_subnet.pri_sub]
}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
  depends_on = [data.aws_subnets.example]
}








