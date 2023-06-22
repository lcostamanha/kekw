floor(sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", status=~"4[0-3][0-9]|4[5-9][0-9]|5[0-9][0-9]", status!="404"}))

floor(sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", status=~"4[0-3][0-9]|4[5-9][0-9]|5[0-9][0-9]", status!="404"}[1m])) * 60)
