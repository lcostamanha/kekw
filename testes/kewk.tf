floor(sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus", status_code=~"(4(?!04)|5).*"}))


floor(sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus", status_code=~"4(?!04).*"}))
