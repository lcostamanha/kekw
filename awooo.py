Parameters:
  ExistingExecutionRoleArn:
    Type: String
  ExistingTaskRoleArn:
    Type: String

Resources:
  TaskDefinition:
    Type: "AWS::ECS::TaskDefinition"
    Properties:
      ExecutionRoleArn: !Ref ExistingExecutionRoleArn
      TaskRoleArn: !Ref ExistingTaskRoleArn
      # Outras propriedades aqui
