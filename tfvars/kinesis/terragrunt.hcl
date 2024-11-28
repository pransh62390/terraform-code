terraform {
  source = "../..//tftemplates/kinesis/data_stream"
  extra_arguments "common_vars" {
    commands = ["init","plan", "apply"]
  }
}

inputs = {
  KINESIS_STREAM_LIST = {
    dynamo-ut-stream = {
      KINESIS_STREAM_MODE_DETAILS = {
        KINESIS_STREAM_MODE = "PROVISIONED"
      }
      KINESIS_STREAM_SHARD_COUNT = 2
      KINESIS_STREAM_RETENTION_PERIOD = 24
    }
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "staging-setup-cloud-platform"
    key            = "stage.terraform.tfstate/ap-south-1/kinesis/data_stream/terraform.tfstate"
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
