provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  db_remote_state_bucket = ""
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  cluster_name = "webservers-production"
}