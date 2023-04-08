provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "db" {
  ami = "ami-005f9685cb30f234b"
  instance_type = "t2.micro" 
} 

resource "aws_instance" "web" {
  ami = "ami-005f9685cb30f234b"
  instance_type = "t2.micro" 

  depends_on = [aws_instance.db]
}

# Auto Approve Command 
# "terraform apply -auto-approve"
# "terraform destroy -auto-approve" 

data "aws_instance" "dbsearch" {
  filter {
    name = "tag:Name"
    values = ["DB Server"]
  }  
}

output "dbservers" {
  value = data.aws_instance.dbsearch.availability_zone
  
}