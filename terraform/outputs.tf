output "tcp_lb_external_ip" {
  value = "${google_compute_forwarding_rule.reddit_app_lb.ip_address}"
}

output "http_lb_external_ip" {
  value = "${google_compute_global_forwarding_rule.reddit_http_lb.ip_address}"
}
