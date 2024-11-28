
variable "vpc_cidr" {}
variable "vpc_enable_dns_support" {}
variable "vpc_enable_dns_hostnames" {}
variable "vpc_tags" {}
variable "short_env" {}
variable "public_subnets" {
  type = list(object({
    CIDR_BLOCK      = string
    AVAILABILITY_ZONE = string
    NAME = string
  }))
}

variable "private_subnets" {
  type = list(object({
    CIDR_BLOCK      = string
    AVAILABILITY_ZONE = string
    NAME = string
  }))
}
