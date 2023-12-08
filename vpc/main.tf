data "aws_vpc" "default"{

}

output "vpc_id" {
  value = data.aws_vpc.default.id
}