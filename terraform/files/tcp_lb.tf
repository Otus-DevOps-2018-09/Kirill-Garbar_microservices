# TCP load balancer

resource "google_compute_forwarding_rule" "reddit_app_lb" {
  name                  = "reddit-app-lb"
  target                = "${google_compute_target_pool.reddit_app_pool.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "9292"
}

resource "google_compute_target_pool" "reddit_app_pool" {
  name = "reddit-app-pool"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.reddit_app.name}",
  ]
}

resource "google_compute_http_health_check" "reddit_app" {
  name               = "reddit-app"
  request_path       = "/"
  port               = 9292
  check_interval_sec = 1
  timeout_sec        = 1
}
