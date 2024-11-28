variable "LONG_ENV" {}
variable "SHORT_ENV" {}
variable "APPLICATION" {}
variable "BUSINESS_UNIT" {}
variable "BUSINESS_UNIT_SUBCATEGORY" {}
variable "BUSINESS_UNIT_EMAIL" {}
variable "COST_CENTRE" {}
variable "AWS_ACCOUNT_SHORT" {}
variable "AWS_ACCOUNT" {}
variable "VPC_NAME" {}

variable "VPC_CIDR" {
    type = string
}

variable "VPC_ENABLE_DNS_SUPPORT" {
    type = bool
    default = false
}
variable "VPC_ENABLE_DNS_HOSTNAMES" {
    type = bool
    default = false
}

variable "PUBLIC_SUBNETS" {
    type = list(object({
        CIDR_BLOCK      = string
        AVAILABILITY_ZONE = string
        NAME = string
    }))

    default = []
}

variable "PRIVATE_SUBNETS" {
    type = list(object({
        CIDR_BLOCK      = string
        AVAILABILITY_ZONE = string
        NAME = string
    }))

    default = []
}
