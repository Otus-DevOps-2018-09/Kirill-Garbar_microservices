resource "google_compute_instance" "awx-autoheal" {
  name         = "awx-autoheal"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["docker-host", "awx-autoheal", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.static_ip.address}"
      }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "static_ip" {
  name = "awx-static-ip"
}
