provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-2" # Setting my region to London. Use your own region here
}

resource "aws_ecr_repository" "scalable_web_app_repo" {
  name = "scalable_web_app" # Naming my repository
}
