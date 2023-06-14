sum by (status_code) (http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", uri!="/actuator/prometheus", status_code=~"2.."})

sum by (status_code) (http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", uri!="/actuator/prometheus", status_code!~"2.."})


sum(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"})


sum by (status_code) (
  http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}
) / ignoring(status_code) group_left sum by (1) (
  http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}
) * 100


sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", status_code=~"2.*"}[5m])) * 100 / sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}[5m]))

---

sus

sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", status_code=~"2.*"}[5m])) * 100 / sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}[5m]))


error

100 - (sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", status_code=~"2.*"}[5m])) * 100 / sum(irate(http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice"}[5m])))
