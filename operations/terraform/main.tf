# HASHICORP PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# PUBLIC SUBNET A
module "public_a" {
  source            = "./modules/aws_subnet"
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  name              = "public-a"
}

# PUBLIC SUBNET B
module "public_b" {
  source            = "./modules/aws_subnet"
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  name              = "public-b"
}

# PRIVATE SUBNET A
module "private_a" {
  source            = "./modules/aws_subnet"
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  name              = "private-a"
}

# PRIVATE SUBNET B
module "private_b" {
  source            = "./modules/aws_subnet"
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  name              = "private-b"
}

# LAUNCH TEMPLATE FOR PUBLIC EKS WORKER NODES
module "public_launch_template" {
  source = "./modules/aws_launch_template"

  name_prefix              = "public-launch-template"
  instance_type            = "t3.medium" # 2 vCPUs, 4GB RAM
  image_id                 = "ami-036dcb2b3ea936d25"
  key_name                 = "notefort-kp"
  associate_public_ip_address = true
  security_groups          = [aws_security_group.public_eks_worker_sg.id]
  volume_size              = 20
  tag_name                 = "eks-public-worker-node"
  eks_cluster_name         = aws_eks_cluster.eks_cluster.name
  depends_on               = [aws_security_group.public_eks_worker_sg]
}

# LAUNCH TEMPLATE FOR PRIVATE EKS WORKER NODES
module "private_launch_template" {
  source = "./modules/aws_launch_template"

  name_prefix              = "private-launch-template"
  instance_type            = "t3.medium" # 2 vCPUs, 4GB RAM
  image_id                 = "ami-036dcb2b3ea936d25"
  key_name                 = "notefort-kp"
  associate_public_ip_address = false
  security_groups          = [aws_security_group.private_eks_worker_sg.id]
  volume_size              = 20
  tag_name                 = "eks-private-worker-node"
  eks_cluster_name         = aws_eks_cluster.eks_cluster.name
  depends_on               = [aws_security_group.private_eks_worker_sg]
}

#PUBLIC EKS NODE GROUP
module "public_eks_node_group" {
  source            = "./modules/aws_eks_node_group"
  cluster_name      = aws_eks_cluster.eks_cluster.name
  node_group_name   = "public-node-group"
  eks_node_role     = aws_iam_role.eks_node_role.arn
  subnet_ids        = [module.public_a.subnet_id, module.public_b.subnet_id]
  launch_template_id = module.public_launch_template.launch_template_id
  desired_size      = 2
  max_size          = 3
  min_size          = 2
  labels             = { "public" = "true" }
  tag_name          = "public-eks-node-group"
  depends_on        = [aws_internet_gateway.main]
}

#PRIVATE EKS NODE GROUP
module "private_eks_node_group" {
  source            = "./modules/aws_eks_node_group"
  cluster_name      = aws_eks_cluster.eks_cluster.name
  node_group_name   = "private-node-group"
  eks_node_role     = aws_iam_role.eks_node_role.arn
  subnet_ids        = [module.private_a.subnet_id, module.private_b.subnet_id]
  launch_template_id = module.private_launch_template.launch_template_id
  desired_size      = 2
  max_size          = 3
  min_size          = 2
  labels             = { "private" = "true" }
  tag_name          = "private-eks-node-group"
  depends_on        = [aws_internet_gateway.main]
}
