# 這裡主要負責建立 VPC、Subnet、Internet Gateway、NAT Gateway
# 架構上是 1 組 VPC + 多AZ的 Public/Private Subnets
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# IGW 讓 Public Subnet 能上網
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block             = var.public_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route" "public_route_igw" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Subnet association to Public RT
resource "aws_route_table_association" "public_rta" {
  count          = length(local.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway 讓private subnet能單向連網
resource "aws_eip" "nat_eip" {
  count = length(local.availability_zones)
  domain   = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(local.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id   # 放在對應的 public subnet
  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.this]
}

# Private Subnets
resource "aws_subnet" "private" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.this.id
  cidr_block             = var.private_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  count = length(local.availability_zones)
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.project_name}-private-rt-${count.index + 1}" }
}

# Each Private Route → NAT Gateway 
resource "aws_route" "private_route_nat" {
  count                   = length(local.availability_zones)
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

# Subnet association to Private RT
resource "aws_route_table_association" "private_rta" {
  count          = length(local.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

# Locals
locals {
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
}

