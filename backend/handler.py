import boto3
import uuid
import os

# Initialize clients for S3 and DynamoDB
s3 = boto3.client("s3", region_name=os.getenv("AWS_REGION", "us-east-1"))
dynamodb = boto3.client("dynamodb", region_name=os.getenv("AWS_REGION", "us-east-1"))
ssm = boto3.client("ssm", region_name=os.getenv("AWS_REGION", "us-east-1"))

# Function to create S3 bucket and a DynamoDB table backend resources
def create_backend_resources(event, context):
    try:
        # Define environment variables (using defaults if not set)
        dynamodb_table_name = "notefort-locks"
        bucket_name_prefix = "notefort-state"
        aws_region = os.getenv("AWS_REGION", "us-east-1")

        # Generate Unique S3 Bucket Name
        unique_id = str(uuid.uuid4()).split('-')[0].lower()
        bucket_name = f"{bucket_name_prefix}-{unique_id}"

        print(f"Generated bucket name: {bucket_name}")

        # Create S3 Bucket
        if aws_region == "us-east-1":
            s3.create_bucket(Bucket=bucket_name)
        else:
            s3.create_bucket(
                Bucket=bucket_name,
                CreateBucketConfiguration={'LocationConstraint': aws_region}
            )

        # Tag S3 Bucket
        s3.put_bucket_tagging(
            Bucket=bucket_name,
            Tagging={
                "TagSet": [
                    {"Key": "Name", "Value": "notefort-state"}
                ]
            }
        )

        # Set S3 Public Access Block
        s3.put_public_access_block(
            Bucket=bucket_name,
            PublicAccessBlockConfiguration={
                "BlockPublicAcls": True,
                "BlockPublicPolicy": True,
                "IgnorePublicAcls": True,
                "RestrictPublicBuckets": True
            }
        )

        # Save Bucket Name to SSM Parameter Store
        ssm.put_parameter(
            Name="notefort-bucket-name",
            Value=bucket_name,
            Type="String",
            Overwrite=True
        )

        # Create DynamoDB Table
        dynamodb.create_table(
            TableName=dynamodb_table_name,
            AttributeDefinitions=[
                {"AttributeName": "LockID", "AttributeType": "S"}
            ],
            KeySchema=[
                {"AttributeName": "LockID", "KeyType": "HASH"}
            ],
            BillingMode="PAY_PER_REQUEST"
        )

        # Return success message
        return {
            "statusCode": 200,
            "body": f"S3 Bucket Name: {bucket_name}\nDynamoDB Table Name: {dynamodb_table_name}\nBACKEND RESOURCES CREATED SUCCESSFULLY"
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": f"Failed to create resources: {str(e)}"
        }

# Function to delete backend resources
def delete_backend_resources(event, context):
    try:
        dynamodb_table_name = "notefort-locks"

        # Retrieve S3 bucket name from SSM Parameter Store
        bucket_name_response = ssm.get_parameter(Name="notefort-bucket-name")
        bucket_name = bucket_name_response["Parameter"]["Value"]

        print(f"Deleting S3 Bucket: {bucket_name}")

        # Delete all objects from the bucket before deleting it
        objects = s3.list_objects_v2(Bucket=bucket_name)
        if "Contents" in objects:
            s3.delete_objects(
                Bucket=bucket_name,
                Delete={
                    "Objects": [{"Key": obj["Key"]} for obj in objects["Contents"]]
                }
            )

        # Delete the S3 bucket
        s3.delete_bucket(Bucket=bucket_name)

        print(f"Deleting DynamoDB Table: {dynamodb_table_name}")

        # Delete the DynamoDB table
        dynamodb.delete_table(TableName=dynamodb_table_name)

        return {
            "statusCode": 200,
            "body": f"S3 Bucket: {bucket_name} | DynamoDB Table: {dynamodb_table_name} | RESOURCES DELETED"
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": f"Failed to delete resources: {str(e)}"
        }
