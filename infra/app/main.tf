
provider "aws" {
  region = var.region
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  stage       = var.stage
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}

#
# EC2
#
data "aws_iam_policy_document" "ec2" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${module.label.id}-eb-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${module.label.id}-eb-ec2"
  role = aws_iam_role.ec2.name
}

resource "aws_elastic_beanstalk_application" "dev_eb_app" {
  name        = "dev-eb-app"
  description = "Elastic Beanstalk development application"
}

resource "aws_elastic_beanstalk_environment" "dev_eb_env" {
  name                = "dev-eb-env"
  description         = "Elastic Beanstalk development environment"
  application         = aws_elastic_beanstalk_application.dev_eb_app.name
  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.0 running Docker 19.03.6-ce"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2.name
    resource  = ""
  }

}


# module "vpc" {
#   source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
#   namespace  = var.namespace
#   stage      = var.stage
#   name       = var.name
#   cidr_block = "172.16.0.0/16"
# }

# module "subnets" {
#   source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
#   namespace          = var.namespace
#   stage              = var.stage
#   name               = var.name
#   vpc_id             = module.vpc.vpc_id
#   igw_id             = module.vpc.igw_id
#   cidr_block         = module.vpc.vpc_cidr_block
#   availability_zones = var.availability_zones

#   nat_gateway_enabled  = true
#   nat_instance_enabled = false
# }

# module "elastic_beanstalk_application" {
#   source      = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-application.git?ref=master"
#   namespace   = var.namespace
#   stage       = var.stage
#   name        = var.name
#   description = "Trading APP - elastic_beanstalk_application"
# }

# module "elastic_beanstalk_environment" {
#   source                             = "git::https://github.com/cloudposse/terraform-aws-elastic-beanstalk-environment.git?ref=master"
#   namespace                          = var.namespace
#   stage                              = var.stage
#   name                               = var.name
#   description                        = "Trading APP - elastic_beanstalk_environment"
#   region                             = var.region
#   availability_zone_selector         = "Any 2"
#   elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name

#   instance_type           = "t3.small"
#   autoscale_min           = 1
#   autoscale_max           = 2
#   updating_min_in_service = 0
#   updating_max_batch      = 1

#   loadbalancer_type       = "application"
#   vpc_id                  = module.vpc.vpc_id
#   loadbalancer_subnets    = module.subnets.public_subnet_ids
#   application_subnets     = module.subnets.private_subnet_ids
#   allowed_security_groups = [module.vpc.vpc_default_security_group_id]

#   // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
#   // https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
#   solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.0 running Docker 19.03.6-ce"

#   additional_settings = [
#     {
#       namespace = "aws:elasticbeanstalk:application:environment"
#       name      = "ANOTHER_ENV_VAR"
#       value     = "123456789"
#     }
#   ]
# }


# # Does not work as it should, for now configuring routing policy manually
# resource "aws_route53_record" "domain_route" {
#   zone_id = var.hosted_zone_id
#   name    = "unicornshepherd.com"
#   type    = "A"
#   # ttl     = "300"
#   # records = [module.elastic_beanstalk_environment.endpoint]
#   alias {
#     name = module.elastic_beanstalk_environment.endpoint
#     zone_id = module.elastic_beanstalk_environment.elb_zone_id
#     evaluate_target_health = true
#   }
# }
