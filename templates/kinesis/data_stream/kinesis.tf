module "kinesis_stream" {
  source = "../..//modules/kinesis/data_stream"
  for_each                                                      = var.KINESIS_STREAM_LIST
  kinesis_stream_name                                           = "${var.SHORT_ENV}-${each.key}"
  kinesis_stream_tags                                           = local.common_tags
  kinesis_stream_shard_count                                    = each.value.KINESIS_STREAM_SHARD_COUNT
  kinesis_stream_retention_period                               = each.value.KINESIS_STREAM_RETENTION_PERIOD
  kinesis_stream_shard_level_metrics                            = each.value.KINESIS_STREAM_SHARD_LEVEL_METRICS
  kinesis_stream_enforce_consumer_deletion                      = each.value.KINESIS_STREAM_ENFORCE_CONSUMER_DELETION
  kinesis_stream_encryption_type                                = each.value.KINESIS_STREAM_ENCRYPTION_TYPE
  kinesis_stream_kms_key_id                                     = each.value.KINESIS_STREAM_KMS_KEY_ID
  kinesis_stream_mode_details                                   = each.value.KINESIS_STREAM_MODE_DETAILS
}
