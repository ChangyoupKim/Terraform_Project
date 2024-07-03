terraform {
  backend "s3" {
    bucket         = "myterraform-bucket-state-changyoup"
    key            = "prod/asg/terraform.tfstate"
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
#                          ASG 생성                           #
###############################################################
module "prod_asg" {
  source            = "github.com/ChangyoupKim/Terraform_Project_LocalModule//aws-asg?ref=v1.1.0" # ( Update )
  instance_type     = "t2.micro"
  desired_capacity  = "2"
  min_size          = "2"
  max_size          = "4"
  name              = "prod"
  private_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.private_subnets
  SSH_SG_ID         = data.terraform_remote_state.vpc_remote_data.outputs.SSH_SG
  HTTP_HTTPS_SG_ID  = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG
  key_name          = "EC2-key"                                                    # 추가된 부분
  target_group_arns = [data.terraform_remote_state.alb_remote_data.outputs.ALB_TG] # 추가된 부분
}
