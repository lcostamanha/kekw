sum by (status_code) (http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", uri!="/actuator/prometheus", status_code=~"2.."})

sum by (status_code) (http_server_requests_seconds_count{task_group="service:service-customeriam-webauthnservice", uri!="/actuator/prometheus", status_code!~"2.."})
