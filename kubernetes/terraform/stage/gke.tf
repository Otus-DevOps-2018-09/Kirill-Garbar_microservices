resource "google_container_cluster" "standard-cluster-1" {
  name               = "${var.cluster_name}"
  zone               = "${var.zone}"
  initial_node_count = "${var.workers_count}"
  # node_version = "${var.cluster_min_ver}"
  min_master_version = "${var.cluster_min_ver}"
  enable_legacy_abac = "false"
  subnetwork = "default"

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
