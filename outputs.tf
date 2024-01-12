output "private_subnets" {
  value = aws_subnet.pri_sub
}
output "public_subnets" {
  value = aws_subnet.pub_sub
}
output "vpc_id" {
  value = data.aws_vpc.vpc_id.id
}