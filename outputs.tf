output "subnet_cidr_blocks" {
  #value = { for s in data.aws_subnet.example : s.tags["Name"] => s.cidr_block}
  value = { for id in data.aws_subnets.example : id.tags["Name"] => id.ids }
}