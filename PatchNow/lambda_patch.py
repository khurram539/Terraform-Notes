import boto3

ssm = boto3.client('ssm')
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Describe EC2 instances tagged with PatchGroup=all
    response = ec2.describe_instances(
        Filters=[{
            'Name': 'tag:PatchGroup',
            'Values': ['all']
        }]
    )

    instance_ids = [
        i['InstanceId']
        for r in response['Reservations']
        for i in r['Instances']
    ]

    if not instance_ids:
        print("No instances found with tag PatchGroup=all")
        return

    print("Patching instances:", instance_ids)

    # Sending SSM command to patch instances
    ssm.send_command(
        InstanceIds=instance_ids,
        DocumentName="AWS-RunPatchBaseline",
        Parameters={"Operation": ["Install"]},
        OutputS3BucketName="kaytheon-system-manager",      # ✅ S3 bucket for logs
        OutputS3KeyPrefix="patch-logs/",                   # Optional prefix (folder path)
        CloudWatchOutputConfig={
            "CloudWatchLogGroupName": "kaytheon-system-manager",  # CloudWatch log group
            "CloudWatchOutputEnabled": True
        }
    )

# run - Compress-Archive -Path lambda_patch.py -DestinationPath lambda.zip -Force
