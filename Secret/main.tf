provider "aws" {
  region = "us-east-1"
}

variable "username" {
    type = string
}

variable "password" {
    type = string
}

provider "vault" {
    auth_login {
      path = "auth/aws/login/var.username"
      parameters = {
        role = "var.role"
      }
    }
}

data "vault_generic_secret" "dbusername" {
    path = "secret/dbusername/"
}

data "vault_generic_secret" "dbpassword" {
    path = "secret/dbpassword/"
}

resource "aws_db_instance" "myRDS" {
    name = "myRDS"
    identifier = "my-first-rds"
    instance_class = db.ts.micro
    engine = "mariaDB"
    engine_version = "10.4.8"
    username = data.dbusername.data["value"]
    password = data.dbpassword.data["value"]
    port = "3306"
    allocated_storage = "20"
    skip_final_snapshot = true
  
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}