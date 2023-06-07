# Get Item
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/getVisitorCount.py"
  output_path = "${path.module}/getVisitorCount_lambda_function_payload.zip"
}
#update Item
data "archive_file" "lambda_update" {
  type        = "zip"
  source_file = "${path.module}/updateVisitorCount.py"
  output_path = "${path.module}/updateVisitorCount_lambda_function_payload.zip"
}
#lambda bucket
resource "aws_s3_bucket" "lambda_bucket"{
  bucket = var.s3_bucket
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl"{
  bucket = aws_s3_bucket.lambda_bucket.id
  acl     = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
# Get Item
resource "aws_s3_object" "s3_object_lambda_code"{
  bucket  = aws_s3_bucket.lambda_bucket.id
  key     = "getVisitorCount_lambda_function_payload.zip"
  source  = data.archive_file.lambda.output_path
  etag    = filemd5(data.archive_file.lambda.output_path) 
}
# Update Item
resource "aws_s3_object" "s3_object_lambda_code_Update"{
  bucket  = aws_s3_bucket.lambda_bucket.id
  key     = "updateVisitorCount_lambda_function_payload.zip"
  source  = data.archive_file.lambda_update.output_path
  etag    = filemd5(data.archive_file.lambda_update.output_path) 
}
#lambda Visitor Counter - Get Item
resource "aws_lambda_function" "get_visitor_count_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  # filename      = "lambda_function_payload.zip"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id 
  s3_key        = aws_s3_object.s3_object_lambda_code.key 
  function_name = "getVisitorCount_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "getVisitorCount.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.10"

}
#lambda Visitor Counter - Update Item
resource "aws_lambda_function" "update_visitor_count_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  # filename      = "lambda_function_payload.zip"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id 
  s3_key        = aws_s3_object.s3_object_lambda_code_Update.key 
  function_name = "updateVisitorCount_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "updateVisitorCount.handler"

  source_code_hash = data.archive_file.lambda_update.output_base64sha256

  runtime = "python3.10"

}
#lambda Policy to assume service
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
#policy to retirve items from dynamoDB
data "aws_iam_policy_document" "dynamoDBLambdaPermissions" {
  statement {
    sid = "PolicyVisitorCounterLambdagetItemFromDynamoDB"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]

    resources = [
      "arn:aws:dynamodb:us-east-1:478748625055:table/eacheampongVisitorCounter",
    ]
  }
}
resource "aws_iam_policy" "dynamoDBLambdaPolicy"{
  name        = "VisitorCounterDynamoLambdaPolicy"
  description = "Policy to add dynamoDB actions getItem actions to role for Lambda"
  policy      = data.aws_iam_policy_document.dynamoDBLambdaPermissions.json 
}
#lambda Role
resource "aws_iam_role" "iam_for_lambda" {
  name               = "VisitorCounter_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
#Add permissions to Lambda role so it can "getItem" from dynamodb
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_intergration_policy_attachment" {
  role        = aws_iam_role.iam_for_lambda.name
  policy_arn  = aws_iam_policy.dynamoDBLambdaPolicy.arn
}
#cloudwatch group
resource "aws_cloudwatch_log_group" "get_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.get_visitor_count_lambda.function_name}"
  retention_in_days = 30
}
#cloudwatch group
resource "aws_cloudwatch_log_group" "update_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.update_visitor_count_lambda.function_name}"
  retention_in_days = 30
}