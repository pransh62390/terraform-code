variable "lambda_name"  {}

# IAM
variable "lambda_assume_role_policy" {}
variable "lambda_managed_policy_arn_list" {}
variable "lambda_tags" {}

# LAMBDA
variable "lambda_bucket_name" {}
variable "lambda_handler" {}
variable "lambda_runtime" {}
variable "lambda_architectures" {}
variable "lambda_description" {}
variable "lambda_memory_size" {}
variable "lambda_reserved_concurrent_executions" {}
variable "lambda_timeout" {}
variable "lambda_package_type" {}
variable "lambda_enable_vpc" {}
variable "subnet_ids" {}
variable "security_group_ids" {}
variable "lambda_env_variables" {}
variable "lambda_dead_letter_target_arn" {}
variable "lambda_ephemeral_memory_size" {default = 512}
variable "lambda_enable_snap_start" {default = false}
variable "lambda_snap_start_config_list" {
  type = map(object({
    LAMBDA_SNAP_START_APPLY_ON = string
  }))
  default = {}
}
variable "lambda_maximum_concurrency" {}

# TRIGGER
variable "lambda_create_trigger" {
  type = bool
  default = true
}
variable "lambda_enable_trigger" {}
variable "lambda_trigger_resource_type" {}
variable "lambda_trigger_batch_size" {}
variable "lambda_trigger_maximum_batching_window_in_seconds" {}
variable "lambda_trigger_function_response_types" {}
variable "lambda_trigger_resource_name" {}
variable "lambda_trigger_filter_criteria_list" {
  type = list(string)
  default = []
}

# INVOKE
variable "lambda_asynchronous_invocation_config" {
  type = bool
  default = true
}
variable "lambda_trigger_maximum_event_age_in_seconds" {}
variable "lambda_trigger_maximum_retry_attempts" {}


#CLOUDWATCH LOG
variable "lambda_cloudwatch_log_group_skip_destroy" {}
variable "lambda_cloudwatch_log_group_retention_in_days" {}
variable "lambda_cloudwatch_log_group_class" {}

variable "optional_config" {
  type        = map(any)
  default     = {}
}

variable "destination_config" {
  type        = map(any)
  default     = {}
}

variable "lambda_layers_arns" {
  type = list(string)
  default = null
}
