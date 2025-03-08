output "node_group_id" {
  description = "The ID of the EKS node group"
  value       = aws_eks_node_group.this.id
}
