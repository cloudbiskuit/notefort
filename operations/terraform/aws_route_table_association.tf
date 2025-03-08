# PUBLIC SUBNET A ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_a" {
  subnet_id      = module.public_a.subnet_id
  route_table_id = aws_route_table.public.id
}

# PUBLIC SUBNET B ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_b" {
  subnet_id      = module.public_b.subnet_id
  route_table_id = aws_route_table.public.id
}

# PRIVATE SUBNET A ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "private_a" {
  subnet_id      = module.private_a.subnet_id
  route_table_id = aws_route_table.private_a.id
}

# PRIVATE SUBNET B ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "private_b" {
  subnet_id      = module.private_b.subnet_id
  route_table_id = aws_route_table.private_b.id
}
