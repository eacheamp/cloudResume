output "visitor_counterLambdaName" {
    value = aws_lambda_function.visitor_counter_lambda.function_name
}
output "visitor_counterLambdarn" {
    value = aws_lambda_function.visitor_counter_lambda.invoke_arn
}
output "dynamoDBLambdaPolicyarn" {
    value = aws_iam_policy.dynamoDBLambdaPolicy.arn
}