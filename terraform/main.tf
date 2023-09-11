data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}
ß
module "lambda" {
  source                         = "./modules/lambda"
  description                    = var.description
  environment                    = var.environment
  filename                       = var.filename
  function_name                  = var.function_name
  handler                        = var.handler
  memory_size                    = var.memory_size
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_object_version
  source_code_hash               = var.source_code_hash
  timeout                        = var.timeout
  tags                           = var.tags
  vpc_config                     = var.vpc_config
}


module "event-s3" {
  source = "./modules/event/s3"
  enable = lookup(var.event, "type", "") == "s3" ? true : false

  lambda_function_arn = module.lambda.arn
  s3_bucket_arn       = lookup(var.event, "s3_bucket_arn", "")
  s3_bucket_id        = lookup(var.event, "s3_bucket_id", "")
}


resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${module.lambda.function_name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_lambda_permission" "cloudwatch_logs" {
  count         = var.logfilter_destination_arn != "" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.logfilter_destination_arn
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.lambda.arn
}

