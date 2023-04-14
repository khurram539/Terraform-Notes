terraform {
    backend "s3"
    {
        bucket = "terraform-stateful-bucket"
        key = "stateful.tfstate"
        region = "us-east-1"
    }
}
