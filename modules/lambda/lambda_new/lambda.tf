data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  dead_letter_config = {
    lambda_dead_letter_target_arn = {
      arn = var.lambda_dead_letter_target_arn
    }
  }
  is_dynamodb = var.lambda_trigger_resource_type == "dynamodb"
  is_sqs      = var.lambda_trigger_resource_type == "sqs"
}

#retrieve dynamodb table stream arn if trigger is dynamo
data "aws_dynamodb_table" "dynamodb_table" {
  count = var.lambda_create_trigger && local.is_dynamodb ? 1 : 0
  name  = var.lambda_trigger_resource_name
}

resource "aws_iam_role" "iam_role" {
  name                  = substr("${var.lambda_name}-lambda", 0, 64)
  assume_role_policy    =  var.lambda_assume_role_policy
  managed_policy_arns   =  var.lambda_managed_policy_arn_list

  tags                  = merge(var.lambda_tags, tomap({"Name" = "${var.lambda_name}-lambda"}))
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket             = var.lambda_bucket_name
  s3_key                = "${var.lambda_tags["Environment"]}.lambda/${var.lambda_name}/${var.lambda_name}.zip"
  function_name         = var.lambda_name
  role                  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${substr("${var.lambda_name}-lambda", 0, 64)}"
  handler               = var.lambda_handler
  runtime               = var.lambda_runtime
  architectures         = var.lambda_architectures
  description           = var.lambda_description
  memory_size           = var.lambda_memory_size
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  timeout               = var.lambda_timeout
  package_type          = var.lambda_package_type
  vpc_config {
    subnet_ids          = var.lambda_enable_vpc ? var.subnet_ids : []
    security_group_ids  = var.lambda_enable_vpc ? var.security_group_ids : []
  }
  dynamic "snap_start" {
    for_each = var.lambda_enable_snap_start ? var.lambda_snap_start_config_list : {}
    content {
      apply_on = snap_start.value.LAMBDA_SNAP_START_APPLY_ON
    }
  }  
  dynamic "dead_letter_config" {
    for_each              = {
      for k,v in local.dead_letter_config : k => v
      if v.arn != null
    }
    content {
      target_arn          = var.lambda_dead_letter_target_arn
    }  
  }

  environment {
    variables           = try(var.lambda_env_variables, {})
  }

  ephemeral_storage {
    size = var.lambda_ephemeral_memory_size
  }

  layers                = var.lambda_layers_arns != null ? var.lambda_layers_arns : null

  tags                  = merge(var.lambda_tags, tomap({"Name" = var.lambda_name}))
}

resource "aws_lambda_event_source_mapping" "trigger" {
  count                                 = var.lambda_create_trigger ? 1 : 0
  function_name                         = aws_lambda_function.lambda_function.arn
  batch_size                            = var.lambda_trigger_batch_size
  enabled                               = var.lambda_enable_trigger
  maximum_batching_window_in_seconds    = var.lambda_trigger_maximum_batching_window_in_seconds
  function_response_types               = var.lambda_trigger_function_response_types
  dynamic "scaling_config" {
    for_each = local.is_sqs && var.lambda_maximum_concurrency > 0 ? [1] : []
    content {
      maximum_concurrency = var.lambda_maximum_concurrency
    }
  }  

  dynamic "filter_criteria"  { 
      for_each = length(var.lambda_trigger_filter_criteria_list) > 0 ? var.lambda_trigger_filter_criteria_list : []
      content {
          filter  {
            pattern  = can(jsondecode(filter_criteria.value)) ? jsondecode(filter_criteria.value) : null
          }
      }
  }

  bisect_batch_on_function_error = lookup(var.optional_config, "bisect_batch_on_function_error", null)
  maximum_retry_attempts = lookup(var.optional_config, "maximum_retry_attempts", null)
  maximum_record_age_in_seconds = lookup(var.optional_config, "maximum_record_age_in_seconds", null)
  parallelization_factor = lookup(var.optional_config, "parallelization_factor", null)
  tumbling_window_in_seconds = lookup(var.optional_config, "tumbling_window_in_seconds", null)
  starting_position = lookup(var.optional_config, "starting_position", null)
  starting_position_timestamp = lookup(var.optional_config, "starting_position_timestamp", null)
  event_source_arn = lookup(var.optional_config, "event_source_arn", "arn:aws:${var.lambda_trigger_resource_type}:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.lambda_trigger_resource_name}")

  dynamic "destination_config" {
    for_each = length(var.destination_config) > 0 ? [1] : []
    content {
      dynamic "on_failure" {
        for_each = lookup(var.destination_config, "on_failure", null) != null ? [1] : []
        content {
          destination_arn = var.destination_config["on_failure"]["destination_arn"]
        }
      }
    }
  }

  tags                                 = var.lambda_tags
  depends_on                            = [ aws_lambda_function.lambda_function ]
}

resource "aws_lambda_function_event_invoke_config" "asynchronous_invocation" {
  count                         = var.lambda_asynchronous_invocation_config ? 1 : 0
  function_name                 = var.lambda_name
  maximum_event_age_in_seconds  = var.lambda_trigger_maximum_event_age_in_seconds
  maximum_retry_attempts        = var.lambda_trigger_maximum_retry_attempts
  depends_on                    = [ aws_lambda_function.lambda_function ]
}

module "lambda_log_group" {
  source                                                = "../../cloudwatch/log_group"
  cloudwatch_log_group_name                             = "/aws/lambda/${var.lambda_name}"
  cloudwatch_log_group_skip_destroy                     = var.lambda_cloudwatch_log_group_skip_destroy
  cloudwatch_log_group_retention_in_days                = var.lambda_cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_class                            = var.lambda_cloudwatch_log_group_class
  cloudwatch_log_group_tags                             = var.lambda_tags
}