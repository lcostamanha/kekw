sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/"})


sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/"}[1m]))
