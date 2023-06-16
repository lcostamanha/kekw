avg(http_server_request_duration_seconds{task_name="family-customeriam-webauthnservice-newvpc", uri!="/api/v1/preregister"})



------------------------------------------------------------------------------------------------

histogram_quantile(0.95, sum(rate(preregister_histogram_bucket{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus"}[5m])) by (le))


histogram_quantile(0.90, sum(rate(preregister_histogram_bucket{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus"}[5m])) by (le))


histogram_quantile(0.50, sum(rate(preregister_histogram_bucket{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus"}[5m])) by (le))

-----------------------------------

avg(http_request_duration_seconds{task_name="family-customeriam-webauthnservice-newvpc", uri!~"/actuator/prometheus"})
