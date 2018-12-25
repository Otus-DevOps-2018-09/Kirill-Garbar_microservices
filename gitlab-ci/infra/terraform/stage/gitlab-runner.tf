resource "google_compute_instance" "runner" {
  name         = "gitlab-runner"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["docker-host", "gitlab-runner"]

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
