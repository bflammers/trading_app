
variable "region" {
    type    = string
    default = "eu-west-1"
}

variable "availability_zones" {
    type    = list(string)
    default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "name" {
    type    = string
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}