resource "aws_kinesis_stream" "kinesis_stream" {
  name                          = var.kinesis_stream_name
  shard_count                   = var.kinesis_stream_shard_count
  retention_period              = var.kinesis_stream_retention_period

  shard_level_metrics           = var.kinesis_stream_shard_level_metrics

  enforce_consumer_deletion     = var.kinesis_stream_enforce_consumer_deletion
  encryption_type               = var.kinesis_stream_encryption_type

  kms_key_id                    = var.kinesis_stream_kms_key_id

  dynamic "stream_mode_details" {
    for_each = length(var.kinesis_stream_mode_details) > 0 ? [var.kinesis_stream_mode_details] : []
    content {
      stream_mode = stream_mode_details.value.KINESIS_STREAM_MODE
    }
  }

  tags                          = merge(var.kinesis_stream_tags, tomap({"Name" = var.kinesis_stream_name}))
}
