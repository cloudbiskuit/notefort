# Additional Security Group for EKS Control Plane
resource "aws_security_group" "eks_additional_sg" {
  name        = "eks-additional-sg"
  description = "Additional security group for EKS control plane"
  vpc_id      = aws_vpc.main.id

  # Inbound rules for API Endpoint access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rules for CoreDNS add-on
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9153
    to_port     = 9153
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for aws-node add-on
  ingress {
    from_port   = 61678
    to_port     = 61678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule for Control Plane internal services
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  # Outbound rule (default allow-all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-additional-sg"
  }
}
