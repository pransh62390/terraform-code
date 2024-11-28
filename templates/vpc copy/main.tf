module "vpc" {
  source = "../../../..//modules/vpc/vpc_new"
  for_each = var.VPC_LIST
  vpc_cidr = each.value.VPC_CIDR
  vpc_enable_dns_support = each.value.VPC_ENABLE_DNS_SUPPORT
  vpc_enable_dns_hostnames = each.value.VPC_ENABLE_DNS_HOSTNAMES
  vpc_tags = local.common_tags
  short_env = var.SHORT_ENV
  public_subnets = each.value.PUBLIC_SUBNETS
  private_subnets = each.value.PRIVATE_SUBNETS
}
