data "aws_vpc" "default"{
  default = true
}

data "aws_subnets" "subnet_ids" {
  vpc_id  = aws_vpc.main.id
}
