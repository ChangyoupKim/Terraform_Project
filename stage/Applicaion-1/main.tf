terraform {
  backend "s3" {
    bucket         = "myterraform-bucket-state-changyoup"
    key            = "stage/app1/terraform.tfstate"
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

module "stage_alb" {
  source           = "github.com/ChangyoupKim/Terraform_Project_LocalModule//aws-alb?ref=v1.1.0"
  name             = "stage"
  vpc_id           = data.terraform_remote_state.vpc_remote_data.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.public_subnets
  HTTP_HTTPS_SG_ID = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG
}



###############################################################
#                          ASG 생성                           #
###############################################################

module "stage_asg" {
  source            = "github.com/ChangyoupKim/Terraform_Project_LocalModule//aws-asg?ref=v1.1.0"
  instance_type     = "t2.micro"
  min_size          = "2"
  max_size          = "3"
  desired_capacity  = 2
  name              = "stage"
  private_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.private_subnets
  SSH_SG_ID         = data.terraform_remote_state.vpc_remote_data.outputs.SSH_SG
  HTTP_HTTPS_SG_ID  = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG
  target_group_arns = [data.terraform_remote_state.app1_remote_data.outputs.ALB_TG]
}

