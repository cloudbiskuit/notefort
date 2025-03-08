# CORE-DNS ADD-ON
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"

  depends_on = [ 
    module.public_eks_node_group,
    module.private_eks_node_group 
  ]
}

# KUBE-PROXY ADD-ON
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

# VPC CNI ADD-ON
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

# EBS CSI DRIVER ADD-ON
resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [ 
    module.public_eks_node_group,
    module.private_eks_node_group 
  ]
}
