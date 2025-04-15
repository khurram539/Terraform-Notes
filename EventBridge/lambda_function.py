import boto3
import os

def lambda_handler(event, context):
    action = event.get('action')
    instances = os.environ['INSTANCE_IDS'].split(',')

    ec2 = boto3.client('ec2')

    if action == 'start':
        ec2.start_instances(InstanceIds=instances)
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=instances)
    else:
        raise ValueError("Invalid action")
