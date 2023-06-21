sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2..", uri="/api/v1/authenticate"}[1m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[1m])) * 100


sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"4..|5..", status!="404", uri="/api/v1/authenticate"}[1m])) / sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}[1m])) * 100
