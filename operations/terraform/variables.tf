# Instance types
variable "private_instance_type" {
  description = "Instance type for private EKS worker nodes"
  type        = string
}

variable "public_instance_type" {
  description = "Instance type for public EKS worker nodes"
  type        = string
}

# Public Node Group scaling sizes
variable "public_desired_size" {
  description = "Desired number of public EKS nodes"
  type        = number
}

variable "public_max_size" {
  description = "Maximum number of public EKS nodes"
  type        = number
}

variable "public_min_size" {
  description = "Minimum number of public EKS nodes"
  type        = number
}

variable "private_desired_size" {
  description = "Desired number of private EKS nodes"
  type        = number
}

variable "private_max_size" {
  description = "Maximum number of private EKS nodes"
  type        = number
}

variable "private_min_size" {
  description = "Minimum number of private EKS nodes"
  type        = number
}
