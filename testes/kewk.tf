sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2(00|04)", uri="/api/v1/preauthenticate"}[5m]))
/ sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[5m]))
* 100
