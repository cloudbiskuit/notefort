# PUBLIC EKS NODE GROUP
resource "aws_eks_node_group" "public_eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "public-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  launch_template {
    id      = aws_launch_template.public_eks_worker_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  labels = {
    "public" = "true"
  }

  tags = {
    Name = "public-eks-node-group"
  }

  depends_on = [aws_internet_gateway.main]
}

# PRIVATE EKS NODE GROUP
resource "aws_eks_node_group" "private_eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "private-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  launch_template {
    id      = aws_launch_template.private_eks_worker_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  labels = {
    "private" = "true"
  }

  tags = {
    Name = "private-eks-node-group"
  }
  
  depends_on = [aws_internet_gateway.main]
}
