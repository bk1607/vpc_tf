data "aws_vpc" "default"{
  default = true
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id  = aws_vpc.main.id
}
output "subnets" {
  value = data.aws_subnet_ids.subnet_ids
}