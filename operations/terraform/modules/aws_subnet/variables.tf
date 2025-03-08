variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The Availability Zone where the subnet will be created"
  type        = string
}

variable "name" {
  description = "The name of the subnet"
  type        = string
}
