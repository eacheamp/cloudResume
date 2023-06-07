output "get_visitor_countLambdaName" {
    value = aws_lambda_function.get_visitor_count_lambda.function_name
}
output "update_visitor_countLambdaName" {
    value = aws_lambda_function.update_visitor_count_lambda.function_name
}
output "get_visitor_countLambdarn" {
    value = aws_lambda_function.get_visitor_count_lambda.invoke_arn
}
output "update_visitor_countLambdarn" {
    value = aws_lambda_function.update_visitor_count_lambda.invoke_arn
}
output "dynamoDBLambdaPolicyarn" {
    value = aws_iam_policy.dynamoDBLambdaPolicy.arn
}
