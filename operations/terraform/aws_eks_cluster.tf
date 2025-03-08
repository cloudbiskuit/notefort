# EKS CLUSTER
resource "aws_eks_cluster" "eks_cluster" {
  name     = "notefort-cluster"
  version  = "1.32"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      module.public_a.subnet_id,
      module.public_b.subnet_id,
      module.private_a.subnet_id,
      module.private_b.subnet_id
    ]    
    endpoint_public_access = true
    // public_access_cidrs = ["${aws_eip.nat_a.public_ip}/32", "${aws_eip.nat_b.public_ip}/32", my-ip/32]
    
    security_group_ids = [ aws_security_group.eks_additional_sg.id ] # Attach the additional Control Plane security group

  }
  
  tags = {
    Name = "notefort-cluster"
  }

  depends_on = [aws_internet_gateway.main]
}
