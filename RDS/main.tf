provider "aws" {
    region = "us-east-1"
}

resource "aws_db_instance" "MyRDS" {
    name = "MyRDS"
    identifier = "my-first-rds"
    instance_class = "db.t2.micro"
    engine = "mysql"
    engine_version = "8.0.32"
    allocated_storage = 20
    username = "xxxxxxxx"
    password = "xxxxxxxx"
    port = 3306
    skip_final_snapshot = true
}
