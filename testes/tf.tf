coalesce(sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", status_code=~"2.*"}[5m])) * 100 / sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}[5m])), 0)


if(sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", status_code=~"2.*"}[5m])) > 0, sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", status_code=~"2.*"}[5m])) * 100 / sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}[5m])), 0)



fields @timestamp, campo_nulo
| filter campo_nulo = "null"
| stats count(*) by campo_nulo
| fields - campo_nulo
| fields @timestamp, campo_nulo="0"
