sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/"})


sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/"}[1m]))




sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/"} offset $__interval)


------

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/", status=~"2.."}[5m]))
/ sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/" }[5m]))
* 100


sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/", status!~"2.."}[5m]))
/ sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri!="/actuator/prometheus", uri!="/" }[5m]))
* 100
