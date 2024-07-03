terraform {
  backend "s3" {
    bucket         = "myterraform-bucket-state-changyoup"
    key            = "prod/alb/terraform.tfstate"
    region         = "ap-northeast-2"
    profile        = "terraform_user"
    dynamodb_table = "myTerraform-bucket-lock-changyoup"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform_user"
}



###############################################################
#                          ALB 생성                           #
###############################################################
module "prod_alb" {
  source           = "github.com/ChangyoupKim/Terraform_Project_LocalModule//aws-alb?ref=v1.1.0" # ( Update )
  name             = "prod"
  vpc_id           = data.terraform_remote_state.vpc_remote_data.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.public_subnets
  HTTP_HTTPS_SG_ID = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG
}
