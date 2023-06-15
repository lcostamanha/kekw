sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[5m])) * 100


if(sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="success", uri!~"/actuator/prometheus|/"}[5m])) > 0,
    100 - (sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[5m])) * 100),
    null
)
