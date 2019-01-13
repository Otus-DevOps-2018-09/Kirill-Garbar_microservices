output "awx_external_ip" {
  value = "${google_compute_instance.awx-autoheal.*.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "reddit_monitoring_external_ip" {
  value = "${google_compute_instance.reddit-monitoring.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
