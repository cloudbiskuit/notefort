resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.eks_node_role
  subnet_ids      = var.subnet_ids

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  labels = var.labels

  tags = {
    Name = var.tag_name
  }
}