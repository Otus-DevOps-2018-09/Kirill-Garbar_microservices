output "gitlab_external_ip" {
  value = "${google_compute_instance.gitlab.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
output "runner_external_ip" {
  value = "${google_compute_instance.runner.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
