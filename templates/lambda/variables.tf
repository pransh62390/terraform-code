variable "APPLICATION" {}
variable "LONG_ENV" {}
variable "SHORT_ENV" {}
variable "BUSINESS_UNIT" {}
variable "BUSINESS_UNIT_SUBCATEGORY" {}
variable "BUSINESS_UNIT_EMAIL" {}
variable "COST_CENTRE" {}
variable "AWS_ACCOUNT_SHORT" {}
variable "AWS_ACCOUNT" {}

variable "LAMBDA_FUNCTION_LIST" {
  type = map(object({
    LAMBDA_FUNCTION_ASSUME_ROLE_POLICY = optional(
        string,
        <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
}
POLICY
    )
    LAMBDA_FUNCTION_MANAGED_POLICY_ARN_LIST = optional(
        list(string),
        [
            "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
            "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
            "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
            "arn:aws:iam::aws:policy/AWSLambdaExecute",
        ]
    )
    LAMBDA_FUNCTION_BUCKET_NAME             = string
    LAMBDA_FUNCTION_HANDLER                 = string
    LAMBDA_FUNCTION_RUNTIME                 = string
    LAMBDA_FUNCTION_ARCHITECTURES           = optional(list(string), ["x86_64"])
    LAMBDA_FUNCTION_DESCRIPTION             = optional(string, "This Lambda is Created By TERRAFORM.")
    LAMBDA_FUNCTION_MEMORY_SIZE             = optional(number, 128)
    LAMBDA_FUNCTION_RESERVED_CONCURRENT_EXECUTIONS = optional(string, "-1")
    LAMBDA_FUNCTION_TIMEOUT                 = optional(number, 3)
    LAMBDA_FUNCTION_PACKAGE_TYPE            = optional(string, "Zip")
    ENABLE_LAMBDA_FUNCTION_VPC              = bool
    SUBNET_IDS                              = optional(list(string), [])
    SECURITY_GROUP_IDS                      = optional(list(string), [])
    LAMBDA_FUNCTION_ENV_VARIABLES           = optional(map(string))
    LAMBDA_FUNCTION_DEAD_LETTER_TARGET_ARN  = optional(string)
    LAMBDA_FUNCTION_ENABLE_TRIGGER          = optional(bool, true)
    LAMBDA_FUNCTION_TRIGGER_RESOURCE_TYPE   = optional(string)
    LAMBDA_FUNCTION_TRIGGER_BATCH_SIZE      = optional(number, 10)
    LAMBDA_MAXIMUM_CONCURRENCY              = optional(number, 0)
    LAMBDA_FUNCTION_TRIGGER_MAXIMUM_BATCHING_WINDOW_IN_SECONDS  = optional(number, 0)
    LAMBDA_FUNCTION_TRIGGER_FUNCTION_RESPONSE_TYPES             = optional(list(string), ["ReportBatchItemFailures"])
    LAMBDA_FUNCTION_TRIGGER_RESOURCE_NAME                       = optional(string)
    LAMBDA_FUNCTION_TRIGGER_MAXIMUM_EVENT_AGE_IN_SECONDS        = optional(number, 21600)
    LAMBDA_FUNCTION_TRIGGER_MAXIMUM_RETRY_ATTEMPTS              = optional(number, 2)
    LAMBDA_CLOUDWATCH_LOG_GROUP_SKIP_DESTROY                    = optional(bool, true)
    LAMBDA_cloudwatch_LOG_GROUP_CLASS                           = optional(string, "STANDARD")
    LAMBDA_cloudwatch_LOG_GROUP_RETENTION_IN_DAYS               = optional(number, 1)
    LAMBDA_FUNCTION_TRIGGER_FILTER_CRITERIA_LIST                = optional(list(string),[])
    LAMBDA_FUNCTION_TRIGGER_OPTIONAL_CONFIG                     = optional(map(any), {})
    LAMBDA_FUNCTION_TRIGGER_DESTINATION_CONFIG                  = optional(map(any), {})
    LAMBDA_LAYERS_ARNS                                          = optional(list(string), [])
  }))
  default = {}
}

# Lambda Layers
variable "LAMBDA_LAYERS_LIST" {
  type = map(object({
    LAMBDA_LAYER_COMPATIBLE_RUNTIMES = optional(list(string), [])
    LAMBDA_LAYER_COMPATIBLE_ARCHITECTURES = optional(list(string), ["x86_64"])
    LAMBDA_LAYER_DESCRIPTION = optional(string, "")
    LAMBDA_LAYER_S3_BUCKET_NAME = optional(string, "")
    LAMBDA_LAYER_S3_KEY = optional(string, "")
    LAMBDA_LAYER_SKIP_DESTROY = optional(bool, false)
  }))
  default = {}
}