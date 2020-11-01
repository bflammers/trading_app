
provider "aws" {
  region = var.region
}

module "label" {
  source      = "../modules/label"
  name        = var.name
}

terraform {
  backend "s3" {

    bucket         = "unicorn-shepherd-terraform-state"
    key            = "dev/vpc/terraform.tfstate"
    region         = "eu-west-1"

    # For state locking
    dynamodb_table = "unicorn-shepherd-terraform-state-locks"
    encrypt        = true
  }
}


# VPC

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = module.label.id

  cidr            = "10.0.0.0/16"

  azs             = var.availability_zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }

  # All for public RDS access - not recommended for production
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true
  enable_dns_hostnames = true
  enable_dns_support   = true

}

# module "vpc" {
#   source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
#   namespace  = "us"
#   stage      = "dev"
#   name       = "dev-vpc"
#   cidr_block = "172.16.0.0/16"
# }

# resource "aws_vpc" "default" {
#   count                            = local.enabled ? 1 : 0
#   cidr_block                       = var.cidr_block
#   instance_tenancy                 = var.instance_tenancy
#   enable_dns_hostnames             = var.enable_dns_hostnames
#   enable_dns_support               = var.enable_dns_support
#   enable_classiclink               = var.enable_classiclink
#   enable_classiclink_dns_support   = var.enable_classiclink_dns_support
#   assign_generated_ipv6_cidr_block = true
#   tags                             = module.label.tags
# }

# # If `aws_default_security_group` is not defined, it would be created implicitly with access `0.0.0.0/0`
# resource "aws_default_security_group" "default" {
#   count  = local.enable_default_security_group_with_custom_rules
#   vpc_id = join("", aws_vpc.default.*.id)

#   tags = merge(module.label.tags, { Name = "Default Security Group" })
# }

# resource "aws_internet_gateway" "default" {
#   count  = local.enable_internet_gateway
#   vpc_id = join("", aws_vpc.default.*.id)
#   tags   = module.label.tags
# }



# ## Subnets

# module "subnets" {
#   source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
#   namespace            = "us"
#   stage                = "dev"
#   name                 = "dev-vpc"
#   vpc_id               = module.vpc.vpc_id
#   igw_id               = module.vpc.igw_id
#   cidr_block           = module.vpc.vpc_cidr_block
#   availability_zones   = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

#   nat_gateway_enabled  = true
#   nat_instance_enabled = false
# }
