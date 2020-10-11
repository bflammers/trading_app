
variable "region" {
    type    = string
    default = "eu-west-1"
}

variable "availability_zones" {
    type    = list(string)
    default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "namespace" {
    type    = string
}

variable "stage" {
    type    = string
}

variable "name" {
    type    = string
}

variable "hosted_zone_id" {
    type    = string
}
