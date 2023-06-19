sum by (status) (rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status=~"2[0-9]{2}", status!="204", uri="/api/v1/preauthenticate"}[5m]))
/ ignoring(status) group_left sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[5m]))
* 100


sum by (status) (rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="204", uri="/api/v1/preauthenticate"}[5m]))
+
sum by (status) (rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", status="error", uri="/api/v1/preauthenticate"}[5m]))
/ ignoring(status) group_left sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[5m]))
* 100
