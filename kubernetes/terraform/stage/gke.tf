resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  zone               = "${var.zone}"
  initial_node_count = "${var.workers_count}"
  min_master_version = "${var.cluster_min_ver}"
  enable_legacy_abac = "false"

  master_auth {
    username = ""
    password = ""
  }

  addons_config {
    kubernetes_dashboard {
      disabled = "false"
    }
  }

  node_config {
    machine_type = "${var.workers_mach_type}"
    disk_size_gb = "${var.workers_disk_size}"

    metadata {
      ssh-keys = "appuser:${file(var.public_key_path)}"
    }

    tags = ["https-server"]
  }
}

resource "google_compute_firewall" "kubernetes_firewall_rule" {
  name    = "allow-kubernetes-apps"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}
