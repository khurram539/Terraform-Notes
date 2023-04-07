terraform {
    backend "s3" {
        bucket = "bucket-name"
        key    = "terraform/terraform.tfstate"
        region = "us-east-1"
        access_key = "xxxxxxxxxxxxxxxxxxxxx"
        secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        
    }
}