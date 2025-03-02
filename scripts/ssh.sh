#!/bin/bash

# Generate SSH key pair
echo "Generating SSH key pair.."
ssh-keygen -t rsa -b 4096 -f ~/.ssh/notefort-kp -N ""
echo "SSH key pair notefort-kp generated successfully"

# Export SSH public key to AWS
echo "Exporting SSH public key to AWS.."
aws ec2 import-key-pair --key-name "notefort-kp" --public-key-material fileb://~/.ssh/notefort-kp.pub
echo "SSH public key notefort-kp exported successfully to AWS"
