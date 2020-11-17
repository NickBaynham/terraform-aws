# Creating an AWS Server

variable "webserver_aws_image" {
  description = "Ubuntu Image to Build Instances from"
  type = string
  default = "ami-0a91cd140a1fc148a"
}

variable "webserver_instance_type" {
  description = "Webserver Instance Type"
  type = string
  default = "t2.micro"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_lb" "web_load_balancer" {
  name = "web-load-balancer"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_load_balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = "404"
    }
  }
}

resource "aws_lb_listener_rule" asg {
  listener_arn = aws_lb_listener.http.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_security_group" "alb" {
  name = "web_load_balancer"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
  name = "web-server-asg"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_launch_configuration" web_launch_config {
  image_id = var.webserver_aws_image
  instance_type = var.webserver_instance_type
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
  		#!/bin/bash
        echo "Hello from AWS" > index.html
        nohup busybox httpd -f -p ${var.server_port} &
        EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" webserver_group {
  launch_configuration = aws_launch_configuration.web_launch_config.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 1
  max_size = 3
}

resource "aws_security_group" instance {
  name = "webserver1-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" default {
  default = true
}

data "aws_subnet_ids" default {
  vpc_id = data.aws_vpc.default.id
}

output "alb_dns_name" {
  value = aws_lb.web_load_balancer.dns_name
  description = "The domain name of the load balancer"
}