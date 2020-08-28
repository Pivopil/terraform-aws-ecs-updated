output "vpc_id" {
  value = aws_vpc.production-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production-vpc.cidr_block
}

output "private_subnets" {
  value = aws_subnet.private-subnet[*].id
}

output "public_subnets" {
  value = aws_subnet.public-subnet[*].id
}
