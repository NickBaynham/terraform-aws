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

variable "min_size" {
  description = "Minimum number of web servers"
  type = number
  default = 1
}

variable "max_size" {
  description = "Maximum number of web servers"
  type = number
  default = 3
}

variable "cluster_name" {
  description = "Name of the Web Server Cluster"
  type = string
  default = "webserver_cluster"
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

 variable "db_remote_state_key" {
   description = "The path for the database's remote state in S3"
   type = string
 }