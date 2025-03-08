# NAT GATEWAY FOR SUBNET A
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.elastic_a.id
  subnet_id     = module.public_a.subnet_id

  tags = {
    Name = "nat-a"
  }
}

# NAT GATEWAY FOR SUBNET B
resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.elastic_b.id
  subnet_id     = module.public_b.subnet_id

  tags = {
    Name = "nat-b"
  }
}