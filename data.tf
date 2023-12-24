data "aws_vpc" "default"{
  default = true
}


data "aws_vpc" "main" {
  tags = {
    Name = "main"
  }
}

data "aws_subnets" "subnet_ids" {
  vpc_id  = data.aws_vpc.main.id

}
