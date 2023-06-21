sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status_code=~"4..|5.."})

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status_code=~"4..|5.."}[1m]))
