module "vpc" {
  source = "../..//modules/vpc/vpc_new"
  vpc_cidr = var.VPC_CIDR
  vpc_enable_dns_support = var.VPC_ENABLE_DNS_SUPPORT
  vpc_enable_dns_hostnames = var.VPC_ENABLE_DNS_HOSTNAMES
  vpc_tags = local.common_tags
  short_env = var.SHORT_ENV
  public_subnets = var.PUBLIC_SUBNETS
  private_subnets = var.PRIVATE_SUBNETS
}
