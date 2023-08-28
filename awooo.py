TaskDefinition:
  UpdateReplacePolicy: Retain
  Type: "AWS::ECS::TaskDefinition"
  Properties:
    ExecutionRoleArn: !Ref TaskExecutionRole
    TaskRoleArn: !Ref TaskDefinitionRole
