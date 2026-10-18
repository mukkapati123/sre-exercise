resource "aws_route_table" "public" {
  count  = 2
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt-${count.index + 1}"
    Type = "Public"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# Three private subnets share two NAT gateways, so the third subnet doubles up on
# the first NAT. Cross-AZ NAT traffic costs extra and the third subnet loses
# egress if that AZ fails - acceptable here, revisit if it carries real traffic.
resource "aws_route_table" "private" {
  count  = 3
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index % 2].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
    Type = "Private"
  }
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
