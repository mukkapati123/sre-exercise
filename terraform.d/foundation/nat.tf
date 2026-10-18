# Two NAT gateways rather than one: a single NAT is a per-AZ failure domain, and
# losing it takes egress down for every private subnet. Two is the cheapest
# option that survives one AZ going away.
resource "aws_eip" "nat" {
  count  = 2
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}
