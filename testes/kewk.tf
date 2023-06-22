floor(sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus", status_code=~"4[^0].."}))

floor(avg(http_server_response_time_seconds{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"}))


floor(avg(http_server_requests_seconds_sum{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"}) / avg(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"}))


avg(http_server_requests_seconds_sum{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"}) / avg(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", uri!="/actuator/prometheus"})
