provider "aws" {
}

terraform {
  backend "s3" {
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zone_names = data.aws_availability_zones.available.names
  az_number               = length(local.availability_zone_names)
  private_subnets_cidrs   = [for intex in range(local.az_number) : cidrsubnet(var.vpc_cidr, 4, intex)]
  public_subnets_cidrs    = [for intex in range(local.az_number) : cidrsubnet(var.vpc_cidr, 4, intex + local.az_number)]
}

resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "Production-VPC"
  }
}

resource "aws_subnet" "public-subnet" {
  count             = length(local.public_subnets_cidrs)
  cidr_block        = local.public_subnets_cidrs[count.index]
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = local.availability_zone_names[count.index]

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(local.private_subnets_cidrs)
  cidr_block        = local.private_subnets_cidrs[count.index]
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = local.availability_zone_names[count.index]

  tags = {
    Name = "Privat-Subnet-${count.index}"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-route-association" {
  count          = length(local.public_subnets_cidrs)
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet[count.index].id
}

resource "aws_route_table_association" "private-route-association" {
  count          = length(local.private_subnets_cidrs)
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet[count.index].id
}

// https://docs.aws.amazon.com/vpc/latest/userguide/vpc-eips.html
resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Production-EIP"
  }

  depends_on = [aws_internet_gateway.production-igw]
}

// https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet[0].id

  tags = {
    Name = "Production-NAT-GW"
  }

  depends_on = [aws_eip.elastic-ip-for-nat-gw]
}

resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Production-IGW"
  }
}

resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
