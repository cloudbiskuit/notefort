# NAT GATEWAY FOR SUBNET A
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.elastic_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "nat-a"
  }
}

# NAT GATEWAY FOR SUBNET B
resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.elastic_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "nat-b"
  }
}