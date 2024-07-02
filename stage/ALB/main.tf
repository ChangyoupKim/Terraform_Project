# 상태파일 저장위치 변경 (Update)
terraform {
  backend "s3" {
    bucket  = "myterraform-bucket-state-changyoup"
    key     = "stage/alb/terraform.tfstate" # (Update)
    region  = "ap-northeast-2"
    profile = "terraform_user"

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

# Source 수정 ( Update )
module "stage_alb" {
  source           = "github.com/ChangyoupKim/Terraform_Project_LocalModule//aws-alb?ref=v1.1.2" # ( Update )
  name             = "stage"
  vpc_id           = data.terraform_remote_state.vpc_remote_data.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.vpc_remote_data.outputs.public_subnets
  HTTP_HTTPS_SG_ID = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG
}
