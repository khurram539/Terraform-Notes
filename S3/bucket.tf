provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "onebucket" {
   bucket = "khurram-s3-bucket-test-test-1"
   acl = "private"
   versioning {
      enabled = true
   }
   tags = {
     Name = "Bucket1"
     Environment = "Test"
   }
}