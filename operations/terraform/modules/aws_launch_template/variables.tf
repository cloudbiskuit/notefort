variable "name_prefix" {
  description = "Prefix for the launch template name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "image_id" {
  description = "AMI ID to be used for the instances"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair to use for instances"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instances"
  type        = bool
  default     = true
}

variable "security_groups" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
}

variable "volume_size" {
  description = "Size of the EBS volume in GiB"
  type        = number
  default     = 20
}

variable "tag_name" {
  description = "Name tag to assign to the instances"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS Cluster name for bootstrap script"
  type        = string
}
