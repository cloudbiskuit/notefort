# ELASTIC IP FOR NAT GATEWAY A
resource "aws_eip" "elastic_a" {
  tags = {
    Name = "nat-eip-a"
  }
}

# ELASTIC IP FOR NAT GATEWAY B
resource "aws_eip" "elastic_b" {
  tags = {
    Name = "nat-eip-b"
  }
}
