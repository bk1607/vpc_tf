data "aws_vpc" "default" {
  default = true
}
data "aws_vpc" "main"{
  tags = {
    Name = "main"
  }
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}








