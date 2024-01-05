data "aws_vpc" "default"{
  default = true
}

data "aws_subnets" "example" {
  filter {
    name   = "tag:Name"
    values = ["public_subnet_1","public_subnet_2"]
  }

}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}








