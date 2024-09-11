terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"  

  backend "s3" {
    bucket = "anyhasher.terraform.states-01"
    key    = "anyhasher-fe.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}

module "alb" {
  source = "./modules/alb"
  
}
