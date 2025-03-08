resource "aws_launch_template" "this" {
  name_prefix   = var.name_prefix
  instance_type = var.instance_type
  image_id      = "ami-036dcb2b3ea936d25"

  key_name = "notefort-kp"

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.tag_name
    }
  }

  user_data = base64encode(<<-EOT
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.eks_cluster_name}
EOT
  )
}
