TargetGroupNew:
  Type: AWS::ElasticLoadBalancingV2::TargetGroup
  DependsOn: LoadBalancerNew
  Properties:
    Port: !Ref ExposedPortInDockerfile
    Protocol: TCP
    VpcId: !Ref VPCIDNEW
    HealthyThresholdCount: 10
    UnhealthyThresholdCount: 10
    TargetGroupAttributes:
      - Key: deregistration_delay.timeout_seconds
        Value: '5'
    TargetType: ip
    HealthCheckProtocol: HTTP
    HealthCheckPort: 'traffic-port' # Utilize o mesmo porto que o tráfego está usando ou especifique um porto específico
    HealthCheckEnabled: true
    HealthCheckPath: '/' # O caminho que o load balancer deve chamar para realizar o health check
    Matcher:
      HttpCode: '200' # Os códigos de resposta para determinar um servidor saudável
