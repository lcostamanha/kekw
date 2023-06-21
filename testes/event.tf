total 

sum(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"})

por min

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[1m]))

médio de res

avg(http_server_requests_seconds_sum{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"} / http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"})

% de erro

100 - (
  sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", status=~"2[0-9]{2}"}[1m])) /
  sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate"}[1m]))
) * 100


por min

sum(rate(http_server_requests_seconds_count{task_name="family-customeriam-webauthnservice-newvpc", uri="/api/v1/preauthenticate", status!~"2[0-9]{2}"}[1m]))

p95 

histogram_quantile(0.95, sum by (le) (preauthenticate_histogram_bucket{task_name="family-customeriam-webauthnservice-newvpc"}))
