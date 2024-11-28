data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    "App"             = var.APPLICATION
    "Environment"     = var.LONG_ENV
    "Env"             = var.SHORT_ENV
    "BU"              = var.BUSINESS_UNIT
    "BUSubcategory"   = var.BUSINESS_UNIT_SUBCATEGORY
    "BUEmail"         = var.BUSINESS_UNIT_EMAIL
    "CC"              = var.COST_CENTRE
    "AwsAccountShort" = var.AWS_ACCOUNT_SHORT
    "AwsAccount"      = var.AWS_ACCOUNT
    "AwsAccountId"    = data.aws_caller_identity.current.account_id
    "ManagedBy"       = "terraform"
  }
}
