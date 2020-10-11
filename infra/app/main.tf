
provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  availability_zones = var.availability_zones

  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "elastic_beanstalk_application" {
  source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=master"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  description = "Test elastic_beanstalk_application"
}

module "elastic_beanstalk_environment" {
  source                             = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
  namespace                          = var.namespace
  stage                              = var.stage
  name                               = var.name
  description                        = "Test elastic_beanstalk_environment"
  region                             = var.region
  availability_zone_selector         = "Any 2"
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name

  instance_type           = "t3.micro"
  autoscale_min           = 1
  autoscale_max           = 2
  updating_min_in_service = 0
  updating_max_batch      = 1

  loadbalancer_type       = "application"
  vpc_id                  = module.vpc.vpc_id
  loadbalancer_subnets    = module.subnets.public_subnet_ids
  application_subnets     = module.subnets.private_subnet_ids
  allowed_security_groups = [module.vpc.vpc_default_security_group_id]

  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
  // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.0 running Docker 19.03.6-ce"

  additional_settings = [
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_HOST"
      value     = "xxxxxxxxxxxxxx"
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_USERNAME"
      value     = "yyyyyyyyyyyyy"
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "DB_PASSWORD"
      value     = "zzzzzzzzzzzzzzzzzzz"
    },
    {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = "ANOTHER_ENV_VAR"
      value     = "123456789"
    }
  ]
}
