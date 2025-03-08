variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "The name of the EKS node group"
  type        = string
}

variable "eks_node_role" {
  description = "The ARN of the IAM role for the EKS node group"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the worker nodes will be provisioned"
  type        = list(string)
}

variable "launch_template_id" {
  description = "The ID of the EC2 launch template"
  type        = string
}

variable "desired_size" {
  description = "The desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
}

variable "labels" {
  type = map(string)
  default = {}
}

variable "tag_name" {
  description = "The tag name for the node group resources"
  type        = string
}
