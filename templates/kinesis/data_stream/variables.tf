variable "KINESIS_STREAM_LIST" {
  type = map(object({
    KINESIS_STREAM_SHARD_COUNT                                  = optional(number, 0) # If the stream_mode is PROVISIONED, this field is required
    KINESIS_STREAM_RETENTION_PERIOD                             = optional(number, 0)
    KINESIS_STREAM_SHARD_LEVEL_METRICS                          = optional(list(string), [])
    KINESIS_STREAM_ENFORCE_CONSUMER_DELETION                    = optional(bool, false)
    KINESIS_STREAM_ENCRYPTION_TYPE                              = optional(string, "NONE")
    KINESIS_STREAM_KMS_KEY_ID                                   = optional(string, "")
    KINESIS_STREAM_MODE_DETAILS                                 = optional(map(string), {})
  }))
  default = {}
}