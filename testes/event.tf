clamp_max(sum(http_server_requests_success_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2[0-9]{2}"}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}) * 100, 100)

100 - clamp_max(sum(http_server_requests_success_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2[0-9]{2}"}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}) * 100, 100)
