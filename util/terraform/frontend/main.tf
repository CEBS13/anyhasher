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

module "ec2" {
  source = "./modules/ec2"
  
}

output "ec2_frontend_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "ec2_frontend_public_url" {
  value = module.ec2.ec2_public_url
}