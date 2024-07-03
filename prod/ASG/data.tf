
data "terraform_remote_state" "vpc_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-changyoup"
    key     = "prod/vpc/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}

data "terraform_remote_state" "alb_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-changyoup"
    key     = "prod/alb/terraform.tfstate" # (Update)
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}

data "terraform_remote_state" "rds_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-changyoup"
    key     = "prod/rds/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}
