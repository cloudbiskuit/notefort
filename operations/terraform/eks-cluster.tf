# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "notefort-cluster"
  version  = "1.32"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id,
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]    
    endpoint_public_access = true
    # public_access_cidrs = ["${aws_eip.nat_a.public_ip}/32", "${aws_eip.nat_b.public_ip}/32", my-ip/32]
    
    # Attach the additional Control Plane security group
    security_group_ids = [ aws_security_group.eks_additional_sg.id ]
  }
  
  tags = {
    Name = "notefort-cluster"
  }

  depends_on = [aws_internet_gateway.main]
}
