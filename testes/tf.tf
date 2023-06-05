apiVersion: v1
kind: Service
metadata:
  name: meu-servico
spec:
  type: LoadBalancer
  ports:
  - port: 8000
    targetPort: 8000
  selector:
    app: meu-aplicativo
