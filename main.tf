# Creating an AWS Server

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" server_1 {
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  tags = {
    name = "ubuntu-1"
  }
}