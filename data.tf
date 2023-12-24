data "aws_vpc" "default"{
  default = true
}


data "aws_vpc" "main" {
  tags = {
    Name = "main"
  }
}



