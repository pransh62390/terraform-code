module "lambda_layers" {
  source = "../../../..//modules/lambda/lambda_layers"
  for_each = var.LAMBDA_LAYERS_LIST
  lambda_layer_name = "${var.SHORT_ENV}-${each.key}"
  lambda_layer_compatible_runtimes = each.value.LAMBDA_LAYER_COMPATIBLE_RUNTIMES
  lambda_layer_compatible_architectures = each.value.LAMBDA_LAYER_COMPATIBLE_ARCHITECTURES
  lambda_layer_description = each.value.LAMBDA_LAYER_DESCRIPTION
  lambda_layer_s3_bucket_name = each.value.LAMBDA_LAYER_S3_BUCKET_NAME
  lambda_layer_s3_key = each.value.LAMBDA_LAYER_S3_KEY
  lambda_layer_skip_destroy = each.value.LAMBDA_LAYER_SKIP_DESTROY
  lambda_layer_tags = local.common_tags
}