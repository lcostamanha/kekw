total de chamadas

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[5m]))


por min

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[1m]))


tempo medio de res

avg(http_server_requests_seconds_sum{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"} / http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"})

erros por min 

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="error", uri="/api/v1/preauthenticate"}[1m]))
