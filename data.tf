data "aws_vpc" "default"{
  default = true
}


#data "aws_vpc" "main" {
#  tags = {
#    Name = "main"
#  }
#}

#data "aws_subnets" "example" {
#  filter {
#    name   = "vpc-id"
#    values = [data.aws_vpc.main.id]
#  }
#  filter {
#    name   = "db-subnet"
#    values = [data.a]
#  }
#}
#
#data "aws_subnet" "example" {
#  for_each = toset(data.aws_subnets.example.ids)
#  id       = each.value
#}

#data "aws_subnets" "vpc_subnets" {
#
#  filter {
#    name   = "tag:Name"
#    values = ["db_private_subnet_1","db_private_subnet_2"]
#  }
#
#  # Add more filters or adjust as needed
#}






