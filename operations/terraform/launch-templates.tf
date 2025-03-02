# EC2 Launch Template for Public EKS Worker Nodes
resource "aws_launch_template" "public_eks_worker_launch_template" {
  name_prefix   = "public-eks-worker-template"
  description   = "Launch template for public EKS worker nodes"
  instance_type = "t3.medium" # 2 vCPUs, 4GB RAM
  image_id      = "ami-036dcb2b3ea936d25"

  key_name = "notefort-kp"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.public_eks_worker_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "public-eks-worker-node"
    }
  }

  user_data = base64encode(<<-EOT
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name}
EOT
  )

  depends_on = [ aws_security_group.public_eks_worker_sg ]
}

# EC2 Launch Template for Private EKS Worker Nodes
resource "aws_launch_template" "private_eks_worker_launch_template" {
  name_prefix   = "private-eks-worker-template"
  description   = "Launch template for private EKS worker nodes"
  instance_type = "t3.medium" # 2 vCPUs, 4GB RAM
  image_id      = "ami-036dcb2b3ea936d25"

  key_name = "notefort-kp"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_eks_worker_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "private-eks-worker-node"
    }
  }

  user_data = base64encode(<<-EOT
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name}
EOT
  )

  depends_on = [ aws_security_group.private_eks_worker_sg ]
}
