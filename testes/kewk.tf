total de chamadas

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[5m]))


sum(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice"} unless(status=~"2..|3.."))


sum(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice", status!~"2..|3.."})


rate(http_server_requests_seconds_count{container_name="container-customeriam-webauthnservice", status!~"2..|3.."}[1m])


---

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status!="2", uri="/api/v1/authenticate"}[1m]))

%

sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"5.."}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}) * 100


sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"4..", uri="/api/v1/authenticate"}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}) * 100


sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"4..|5..", status!="404", uri="/api/v1/authenticate"}) / sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc"}) * 100
