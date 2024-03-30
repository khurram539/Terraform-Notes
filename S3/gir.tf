# create new s3 bucket with lifecycle rule to transition to Glacier Instant Retrieval storage class

resource "aws_s3_bucket" "bucket" {
    bucket = "aws-000000000-terraform"
    acl    = "private"

    lifecycle_rule {
        id      = "Glacier-Instant-Transition"
        enabled = true       

        transition {
            days          = 0
            storage_class = "GLACIER_IR"
        }
    }
}