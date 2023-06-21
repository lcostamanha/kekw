(sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2..", uri="/api/v1/authenticate"}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"})) * 100



(sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2..", uri="/api/v1/authenticate"}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"})) * 100
