variable "kinesis_stream_name" {
  type = string
}

variable "kinesis_stream_shard_count" {
  type = number
}

variable "kinesis_stream_retention_period" {
  type = number
}

variable "kinesis_stream_shard_level_metrics" {
  type = list(string)
}

variable "kinesis_stream_enforce_consumer_deletion" {
  type = bool
}

variable "kinesis_stream_encryption_type" {
  type = string
}

variable "kinesis_stream_kms_key_id" {
  type = string
}

variable "kinesis_stream_tags" {
}

variable "kinesis_stream_mode_details" {
  type    = map(string)
  default = {}
}
