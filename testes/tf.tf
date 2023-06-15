http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}


sus:
http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}

erro:
sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status_code!~"2.*"}[5m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[5m])) * 100


sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[5m])) * 100
