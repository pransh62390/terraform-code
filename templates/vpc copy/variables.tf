variable "LONG_ENV" {}
variable "SHORT_ENV" {}
variable "APPLICATION" {}
variable "BUSINESS_UNIT" {}
variable "BUSINESS_UNIT_SUBCATEGORY" {}
variable "BUSINESS_UNIT_EMAIL" {}
variable "COST_CENTRE" {}
variable "AWS_ACCOUNT_SHORT" {}
variable "AWS_ACCOUNT" {}

variable "VPC_LIST" {
  type = map(object({
    VPC_CIDR = string
    VPC_ENABLE_DNS_SUPPORT = optional(bool, false)
    VPC_ENABLE_DNS_HOSTNAMES = optional(bool, false)
    PUBLIC_SUBNETS = optional(list(object({
      CIDR_BLOCK      = string
      AVAILABILITY_ZONE = string
      NAME = string
    })), [])
    PRIVATE_SUBNETS = optional(list(object({
      CIDR_BLOCK      = string
      AVAILABILITY_ZONE = string
      NAME = string
    })), [])
  }))
}
