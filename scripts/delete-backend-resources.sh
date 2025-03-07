#!/bin/bash

# Set environment variables
DYNAMODB_TABLE_NAME="notefort-locks"

# Fetch the bucket name from AWS Systems Manager Parameter Store (ASM)
BUCKET_NAME=$(aws ssm get-parameter --name "notefort-bucket-name" --query "Parameter.Value" --output text)

# Empty the S3 bucket and delete it
aws s3 rm "s3://${BUCKET_NAME}" --recursive
aws s3api delete-bucket --bucket "${BUCKET_NAME}"

# Delete the DynamoDB Table
aws dynamodb delete-table --table-name "${DYNAMODB_TABLE_NAME}"

# Remove parameters from AWS Systems Manager (ASM)
aws ssm delete-parameter --name "notefort-bucket-name"
aws ssm delete-parameter --name "notefort-image-tag"

echo "BACKEND RESOURCES DELETED SUCCESSFULLY"
