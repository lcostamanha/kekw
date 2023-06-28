sum by (status) (increase(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", status="200"}[$__range]))

sum by (status) (increase(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", status=~"4..|5.."}[$__range]))
