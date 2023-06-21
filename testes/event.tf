sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2.."}[1m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[1m])) * 100

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"4..|5..", uri!="/actuator/prometheus"}[1m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus"}[1m])) * 100


sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2.."}[1m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[1m])) * 100 or
sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"4..|5..", uri!="/actuator/prometheus"}[1m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus"}[1m])) * 100
