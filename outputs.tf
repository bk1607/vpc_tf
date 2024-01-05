output "subnet_cidr_blocks" {
  #value = [for s in data.aws_subnet.example : s.cidr_block]
  value = data.aws_subnet.example
}