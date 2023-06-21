100 - (
  sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2[0-9]{2}"}) /
  sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"})
) * 100
