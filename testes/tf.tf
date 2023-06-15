sum by (status)(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status!="error", uri!~"/actuator/prometheus|/"}[5m])) / ignoring(status) group_left sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) * 100


sum by (status)(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="error", uri!~"/actuator/prometheus|/"}[5m])) / ignoring(status) group_left sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) * 100


sum by (status)(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="error", uri!~"/actuator/prometheus|/"}[5m])) / ignoring(status) group_left sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) * 100



sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="error", uri!~"/actuator/prometheus|/"}[5m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus|/"}[5m])) * 100

