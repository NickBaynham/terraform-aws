# Creating an AWS Server

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" server_1 {
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
  		#!/bin/bash
                echo "Hello from AWS" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF

  tags = {
    Name = "webserver1"
  }
}

resource "aws_security_group" instance {
  name = "webserver1-instance"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}