data "aws_vpc" "default"{
  default = true
}

data "aws_subnets" "example" {


}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}








