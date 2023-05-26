output "private_subnets_id" {
  value = aws_subnet.private.*.id
}

output "public_subnets_id" {
  value = aws_subnet.public.*.id
}

output "vpc_id" {
  value = aws_vpc.aws-vpc.id
}

output "private_cidr_block" {
  value = aws_subnet.private.*.cidr_block
}