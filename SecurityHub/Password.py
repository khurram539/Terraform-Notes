# Use this code snippet in your app.
# If you need more information about configurations
# or implementing the sample code, visit the AWS docs:
# https://aws.amazon.com/developer/language/python/

import boto3
from botocore.exceptions import ClientError


def get_secret():
    secret_name = "directory-service-password"
    region_name = "us-east-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # Handle exceptions thrown by AWS Secrets Manager
        print(f"Error retrieving secret: {e}")
        raise e

    # Extract the secret value
    if 'SecretString' in get_secret_value_response:
        secret = get_secret_value_response['SecretString']
    else:
        secret = get_secret_value_response['SecretBinary']

    return secret


if __name__ == "__main__":
    try:
        secret_value = get_secret()
        print(f"Retrieved secret: {secret_value}")
    except Exception as e:
        print(f"Failed to retrieve secret: {e}")
