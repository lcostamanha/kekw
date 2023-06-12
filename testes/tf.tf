sum(rate(http_requests_total{status="success"}[5m])) by (container_name)
