sum(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice", status="200"}) as "Sucesso",
sum(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice", status="500"}) as "Erro"
