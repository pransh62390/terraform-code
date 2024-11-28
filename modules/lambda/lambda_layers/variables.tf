# lambda layer variables

variable "lambda_layer_name" {
  type = string
}

variable "lambda_layer_compatible_runtimes" {
  type = list(string)
}

variable "lambda_layer_compatible_architectures" {
  type = list(string)
}

variable "lambda_layer_description" {
  type = string
}

variable "lambda_layer_s3_bucket_name" {
  type = string
}

variable "lambda_layer_s3_key" {
  type = string
}

variable "lambda_layer_skip_destroy" {
  type = bool
}

variable "lambda_layer_tags" {}