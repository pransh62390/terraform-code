terraform {
  source = "../../../../../..//tftemplates/stage/common/vpc/"
  extra_arguments "common_vars" {
    commands = ["init","plan", "apply"]
  }
}

inputs = {
  APPLICATION = "all"
  LONG_ENV    = "stage"
  SHORT_ENV   = "stg"
  BUSINESS_UNIT = "all"
  BUSINESS_UNIT_SUBCATEGORY = ""
  BUSINESS_UNIT_EMAIL = ""
  COST_CENTRE = ""
  AWS_ACCOUNT_SHORT = "ss"
  AWS_ACCOUNT = ""

  VPC_CIDR = "10.3.0.0/16"
  VPC_NAME = "stg"
  VPC_ENABLE_DNS_SUPPORT = true
  VPC_ENABLE_DNS_HOSTNAMES = true

  PUBLIC_SUBNETS = [
    {
      CIDR_BLOCK      = "10.3.0.0/24"
      AVAILABILITY_ZONE = "ap-south-1a"
      NAME = "stg-public-subnet-1a"
    },
    {
      CIDR_BLOCK      = "10.3.1.0/24"
      AVAILABILITY_ZONE = "ap-south-1b"
      NAME = "stg-public-subnet-1b"
    },
    {
      CIDR_BLOCK      = "10.3.4.0/24"
      AVAILABILITY_ZONE = "ap-south-1c"
      NAME = "stg-public-subnet-1c"
    }
  ]

  PRIVATE_SUBNETS = [
    {
      CIDR_BLOCK      = "10.3.2.0/24"
      AVAILABILITY_ZONE = "ap-south-1a"
      NAME = "stg-private-subnet-1a"
    },
    {
      CIDR_BLOCK      = "10.3.3.0/24"
      AVAILABILITY_ZONE = "ap-south-1b"
      NAME = "stg-private-subnet-1b"
    },
    {
      CIDR_BLOCK      = "10.3.5.0/24"
      AVAILABILITY_ZONE = "ap-south-1c"
      NAME = "stg-private-subnet-1c"
    }
  ]
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "staging-setup-cloud-platform"
    key            = "stage.terraform.tfstate/ap-south-1/common/vpc/terraform.tfstate"
    region         = "ap-south-1"
  }
}
EOF
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_version = ">= 1.4.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.21.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}
EOF
}
