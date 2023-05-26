resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
  count                 = length(var.public_subnets)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)

  vpc = true

  tags = {
    Name        = "${var.app_name}-nat-eip-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "${var.app_name}-nat-gw-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-private"
    Environment = var.app_environment
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private" {
  count                  = length(var.private_subnets)
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
}
