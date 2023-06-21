total de chamadas

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[5m]))


sum(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice"} unless(status=~"2..|3.."))
