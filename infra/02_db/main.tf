
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {

    bucket         = "unicorn-shepherd-terraform-state"
    key            = "dev/db/terraform.tfstate"
    region         = "eu-west-1"

    # For state locking
    dynamodb_table = "unicorn-shepherd-terraform-state-locks"
    encrypt        = true
  }
}

module "label" {
  source      = "../modules/label"
  name        = var.name
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "unicorn-shepherd-terraform-state"
    key     = "dev/vpc/terraform.tfstate"
    region  = "eu-west-1"
  }
}

# output "test" {
#   value = data.terraform_remote_state.vpc.outputs.id
# }

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################

# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnet_ids" "all" {
#   vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
# }

data "aws_security_group" "default" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  name   = "default"
}

#####
# DB
#####
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "sql-postgres"

  engine            = "postgres"
  engine_version    = "9.6.9"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "postgres"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "postgres"

  password = "postgres"
  port     = "5432"

  vpc_security_group_ids = [data.aws_security_group.default.id]
  publicly_accessible = true

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets

  # DB parameter group
  family = "postgres9.6"

  # DB option group
  major_engine_version = "9.6"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  # Database Deletion Protection
  deletion_protection = false
}

#
# EC2
#
#data "aws_iam_policy_document" "ec2" {
#  statement {
#    sid = ""
#
#    actions = [
#      "sts:AssumeRole",
#    ]
#
#    principals {
#      type        = "Service"
#      identifiers = ["ec2.amazonaws.com"]
#    }
#
#    effect = "Allow"
#  }
#
#  statement {
#    sid = ""
#
#    actions = [
#      "sts:AssumeRole",
#    ]
#
#    principals {
#      type        = "Service"
#      identifiers = ["ssm.amazonaws.com"]
#    }
#
#    effect = "Allow"
#  }
#}
#
#resource "aws_iam_role" "ec2" {
#  name               = "${module.label.id}-eb-ec2"
#  assume_role_policy = data.aws_iam_policy_document.ec2.json
#}
#
#resource "aws_iam_instance_profile" "ec2" {
#  name = "${module.label.id}-eb-ec2"
#  role = aws_iam_role.ec2.name
#}
#
#resource "aws_elastic_beanstalk_application" "dev_eb_db_app" {
#  name        = "dev-eb-db-app"
#  description = "Elastic Beanstalk development application"
#}
#
#resource "aws_elastic_beanstalk_environment" "dev_eb_db_env" {
#  name                = "dev-eb-db-env"
#  description         = "Elastic Beanstalk development environment"
#  application         = aws_elastic_beanstalk_application.dev_eb_db_app.name
#  tier                = "WebServer"
#  solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.0 running Docker 19.03.6-ce"
#
#  setting {
#    namespace = "aws:autoscaling:launchconfiguration"
#    name      = "IamInstanceProfile"
#    value     = aws_iam_instance_profile.ec2.name
#    resource  = ""
#  }
#
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "POSTGRES_DB"
#    value     = "postgres"
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "POSTGRES_USER"
#    value     = "postgres"
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "POSTGRES_PASSWORD"
#    value     = "postgres"
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "DJANGO_DEBUG"
#    value     = 1
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "DJANGO_SECRET_KEY"
#    value     = "password"
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "SQL_ENGINE"
#    value     = "django.db.backends.postgresql"
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "SQL_HOST"
#    value     = module.db.this_db_instance_endpoint
#  }
#  setting {
#    namespace = "aws:elasticbeanstalk:application:environment"
#    name      = "SQL_PORT"
#    value     = module.db.this_db_instance_port
#  }
#
#}
