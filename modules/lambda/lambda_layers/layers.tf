resource "aws_lambda_layer_version" "lambda_layer" {
  # filename   = var.lambda_layer_filename
  layer_name = var.lambda_layer_name
  compatible_runtimes = var.lambda_layer_compatible_runtimes
  compatible_architectures = var.lambda_layer_compatible_architectures
  description = var.lambda_layer_description
  s3_bucket = var.lambda_layer_s3_bucket_name
  s3_key = var.lambda_layer_s3_key != "" ? var.lambda_layer_s3_key : "${var.lambda_layer_tags["Environment"]}.lambda.layers/${var.lambda_layer_name}/${var.lambda_layer_name}.zip"
  skip_destroy = var.lambda_layer_skip_destroy
}