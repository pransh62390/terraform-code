terraform {
  source = "../..//tftemplates/lambda"
  extra_arguments "common_vars" {
    commands = ["init","plan", "apply"]
  }
}

# dependency "lambda_layer_arn_list" {
#   config_path = "../data-01"
# }

inputs = {
  LONG_ENV = "stage"
  SHORT_ENV  = "stg"
  APPLICATION = "all"
  BUSINESS_UNIT  = ""
  BUSINESS_UNIT_SUBCATEGORY  = ""
  BUSINESS_UNIT_EMAIL = ""
  COST_CENTRE   = ""
  AWS_ACCOUNT_SHORT = ""
  AWS_ACCOUNT = ""

  LAMBDA_LAYERS_LIST = {
    data-01-persist-ut-dynamo-layer = {
      LAMBDA_LAYER_COMPATIBLE_RUNTIMES = ["python3.11"]
      LAMBDA_LAYER_DESCRIPTION = "lambda layer version 1"
      LAMBDA_LAYER_S3_BUCKET_NAME = "staging-setup-cloud-platform"
    }
  }

  LAMBDA_FUNCTION_LIST = {
    data-01-persist-ut-dynamo = {
      LAMBDA_FUNCTION_BUCKET_NAME = "staging-setup-cloud-platform"
      LAMBDA_FUNCTION_HANDLER = "lambda_function.lambda_handler"
      LAMBDA_FUNCTION_RUNTIME = "python3.11"
      LAMBDA_FUNCTION_MEMORY_SIZE   = 512
      ENABLE_LAMBDA_FUNCTION_VPC    = false
      LAMBDA_FUNCTION_TRIGGER_RESOURCE_TYPE = "kinesis"
      LAMBDA_FUNCTION_TRIGGER_BATCH_SIZE = 100
      LAMBDA_FUNCTION_TRIGGER_RESOURCE_NAME = ""
      LAMBDA_FUNCTION_TRIGGER_MAXIMUM_BATCHING_WINDOW_IN_SECONDS = 1
      LAMBDA_FUNCTION_TRIGGER_OPTIONAL_CONFIG = {
        bisect_batch_on_function_error = true
        maximum_retry_attempts = -1
        starting_position = "LATEST"
        event_source_arn = "arn:aws:kinesis:ap-south-1::stream/stg-dynamo-stream"
      }
      LAMBDA_FUNCTION_TRIGGER_DESTINATION_CONFIG = {
        on_failure = {
          destination_arn = "arn:aws:sqs:ap-south-1::stg-queue"
        }
      }
      LAMBDA_LAYERS_ARNS = ["arn:aws:lambda:ap-south-1::layer:stg-layer:1"]
      # LAMBDA_LAYERS_ARNS = [dependency.lambda_layer_arn_list.outputs.LAMBDA_LAYER_ARN[0]]
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
    key            = "stage.terraform.tfstate/ap-south-1/lambda/terraform.tfstate"
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
