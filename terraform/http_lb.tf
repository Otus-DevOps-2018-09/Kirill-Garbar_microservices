# HTTP load balancer

resource "google_compute_global_forwarding_rule" "reddit_http_lb" {
  project = "${var.project}"
  name = "reddit-http-lb"
  target = "${google_compute_target_http_proxy.default.self_link}"
  ip_address = "${google_compute_global_address.default.address}"
  port_range = "80"

  depends_on = [
    "google_compute_global_address.default",
  ]
}

resource "google_compute_global_address" "default" {
  project = "${var.project}"
  name = "default"
}

resource "google_compute_target_http_proxy" "default" {
  project = "${var.project}"
  name = "default"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  name = "default"
  default_service = "${google_compute_backend_service.default.self_link}"
}

resource "google_compute_backend_service" "default" {
  name = "default"
  port_name = "http"
  protocol = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group_manager.reddit_apps.instance_group}"
  }

  health_checks = [
    "${google_compute_http_health_check.reddit_app.self_link}",
  ]
}

resource "google_compute_instance_group_manager" "reddit_apps" {
  base_instance_name = "reddit-app"
  name = "reddit-apps"
  instance_template = "${google_compute_instance_template.reddit_app_template.self_link}"
  target_size = 3
  zone = "${var.zone}"

  named_port {
    name = "http"
    port = 9292
  }
}

resource "google_compute_instance_template" "reddit_app_template" {
  name = "reddit-app-template"
  machine_type = "f1-micro"

  network_interface {
    network = "default"
  }

  "disk" {
    source_image = "reddit-full"
  }

  tags = [
    "reddit-app",
  ]
}
