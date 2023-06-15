output "visitor_countLambdaName" {
    value = aws_lambda_function.visitor_count_lambda.function_name
}

output "visitor_countLambdarn" {
    value = aws_lambda_function.visitor_count_lambda.invoke_arn
}

output "dynamoDBLambdaPolicyarn" {
    value = aws_iam_policy.dynamoDBLambdaPolicy.arn
}
