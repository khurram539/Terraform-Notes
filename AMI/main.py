import boto3

def list_amis():
	# Create an EC2 resource
	ec2 = boto3.resource('ec2')

	# List all AMIs
	images = ec2.images.filter(Owners=['self'])  # Use 'self' to list AMIs owned by you; remove filter to list all available AMIs

	for image in images:
		print(f"ID: {image.id}, Name: {image.name}, Status: {image.state}")

if __name__ == "__main__":
	list_amis()