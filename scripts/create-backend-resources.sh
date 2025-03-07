#!/bin/bash

# Define environment variables
DYNAMODB_TABLE_NAME="notefort-locks"
BUCKET_NAME_PREFIX="notefort-state"
AWS_REGION="us-east-1"  # Change as needed

# Generate Unique S3 Bucket Name
UNIQUE_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-8)
BUCKET_NAME="$BUCKET_NAME_PREFIX-$UNIQUE_ID"
echo "Generated bucket name: $BUCKET_NAME"

# Configure AWS CLI with assumed role (Ensure AWS CLI v2 is installed)
aws configure set region $AWS_REGION

# Create S3 Bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $AWS_REGION 

# Tag S3 Bucket
aws s3api put-bucket-tagging \
  --bucket $BUCKET_NAME \
  --tagging "TagSet=[{Key=Name,Value=notefort-state}]"

# Set S3 Public Access Block
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration "BlockPublicAcls=true,BlockPublicPolicy=true,IgnorePublicAcls=true,RestrictPublicBuckets=true"

# Save Bucket Name to Parameter Store
aws ssm put-parameter \
  --name "notefort-bucket-name" \
  --value $BUCKET_NAME \
  --type String \
  --overwrite

# Create DynamoDB Table
aws dynamodb create-table \
  --table-name $DYNAMODB_TABLE_NAME \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $AWS_REGION

echo "S3 Bucket Name: $BUCKET_NAME"
echo "DynamoDB Table Name: $DYNAMODB_TABLE_NAME"
echo "BACKEND RESOURCES CREATED SUCCESSFULLY"
