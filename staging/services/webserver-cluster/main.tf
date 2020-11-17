provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  db_remote_state_bucket = ""
  db_remote_state_key = ""
  cluster_name = "webservers-staging"
}