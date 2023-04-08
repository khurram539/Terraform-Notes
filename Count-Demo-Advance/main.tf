provider "aws" {
    region = "us-east-1"
}    

module "db" {
    source = "./db"
    server_name = ["mariadb", "mysql", "mssql"]
}     

output "private_ips" {
    value = module.db.PrivateIP
}
