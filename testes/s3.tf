# Crie o recurso do EventBridge
resource "aws_cloudwatch_event_rule" "daily_lambda_trigger" {
  name        = "daily_lambda_trigger"
  description = "Chama a função Lambda todos os dias às 05:00 da manhã"

  schedule_expression = "cron(0 5 * * ? *)"  # Define a expressão cron para 05:00 AM

  # Defina os detalhes da ação a ser tomada
  target {
    arn  = aws_lambda_function.my_lambda.arn  # ARN da função Lambda
    role_arn = aws_iam_role.lambda_role.arn   # ARN da função IAM do Lambda com permissões necessárias
  }
}
