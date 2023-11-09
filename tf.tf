TargetGroupNew:
  Type: AWS::ElasticLoadBalancingV2::TargetGroup
  DependsOn: LoadBalancerNew
  Properties:
    Port: !Ref ExposedPortInDockerfile
    Protocol: TCP
    VpcId: !Ref VPCIDNEW
    HealthyThresholdCount: 10
    UnhealthyThresholdCount: 10
    HealthCheckProtocol: HTTP
    HealthCheckPath: '/' # Ou o caminho específico para a verificação de saúde da sua aplicação
    HealthCheckPort: 'traffic-port' # Utiliza a mesma porta de tráfego para o health check, ou especifique uma porta.
    HealthCheckEnabled: true # Certifique-se de que a verificação de saúde está habilitada.
    HealthCheckIntervalSeconds: 30 # O intervalo entre as verificações de saúde.
    HealthCheckTimeoutSeconds: 5 # O número de segundos durante os quais nenhuma resposta significa uma falha de health check.
    TargetGroupAttributes:
      - Key: deregistration_delay.timeout_seconds
        Value: '5'
    TargetType: ip
