# Criação da regra do EventBridge
resource "aws_cloudwatch_event_rule" "example_event_rule" {
  name        = "my-event-rule"
  description = "Regra para invocar a função Lambda a cada cinco minutos"

  schedule_expression = "rate(5 minutes)"  # Expressão de agendamento para invocação a cada cinco minutos
}

# Associação da regra do EventBridge com a função Lambda
resource "aws_cloudwatch_event_target" "example_event_target" {
  rule      = aws_cloudwatch_event_rule.example_event_rule.name
  target_id = aws_lambda_function.example_lambda.function_name
  arn       = aws_lambda_function.example_lambda.arn
}
