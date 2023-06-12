sum(rate(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice", status="success"}[5m])) by (status)


+ sum(rate(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice", status="error"}[5m])) by (status)
