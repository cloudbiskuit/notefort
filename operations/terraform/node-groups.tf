# Public EKS Node Group
resource "aws_eks_node_group" "public_eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "public-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  launch_template {
    id      = aws_launch_template.public_eks_worker_launch_template.id
    version = "$Latest"
  }

  # Adjust the desired size of the nodes here
  scaling_config {
    desired_size = 2  # The system will launch with desired nodes 
    max_size     = 3  # The system can scale up to a max
    min_size     = 2  # The system can scale down to min node but never below that
  }

  labels = {
    "public" = "true"
  }

  tags = {
    Name = "public-eks-node-group"
  }

  depends_on = [aws_internet_gateway.main]
}

# Private EKS Node Group Creation
resource "aws_eks_node_group" "private_eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "private-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  launch_template {
    id      = aws_launch_template.private_eks_worker_launch_template.id
    version = "$Latest"
  }

  # Adjust the desired size of the nodes here
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
