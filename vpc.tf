resource "aws_vpc" "bg_vpc" {
  cidr_block = var.vpc_cidr


  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.bg_vpc.id
  cidr_block        = var.cidr_public_1
  availability_zone = var.az_1

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.bg_vpc.id
  cidr_block        = var.cidr_public_2
  availability_zone = var.az_2

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.bg_vpc.id
  cidr_block        = var.cidr_private_1
  availability_zone = var.az_1

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.bg_vpc.id
  cidr_block        = var.cidr_private_2
  availability_zone = var.az_2

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bg_vpc.id

  tags = {
    Name = "I-GW"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "NAT-GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "internet_route_tbl" {
  vpc_id = aws_vpc.bg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "internet-route-table"
  }
}

resource "aws_route_table" "nat_route_tbl" {
  vpc_id = aws_vpc.bg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "nat-route-table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.internet_route_tbl.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.internet_route_tbl.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.nat_route_tbl.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.nat_route_tbl.id
}
