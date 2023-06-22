floor(sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"}[1m])) * 60)
