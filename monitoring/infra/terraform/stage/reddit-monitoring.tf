resource "google_compute_instance" "reddit-monitoring" {
  name         = "reddit-monitoring"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["reddit-monitoring", "docker-host", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
