floor(sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"}[1m])) * 60)


floor(sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus", status=~"4..|5..", status!="404"}[1m])) * 60)

sum by (status_code) (http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"})
