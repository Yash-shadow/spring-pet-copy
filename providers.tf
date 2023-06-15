provider "aws" {
  region     = "us-west-2"
  access_key = var.secret_key
  secret_key = var.secret_key_pas
}