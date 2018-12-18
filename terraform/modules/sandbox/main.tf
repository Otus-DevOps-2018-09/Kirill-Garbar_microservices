resource "google_compute_instance" "sandbox" {
  name         = "sandbox"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  tags = [
    "sandbox",
  ]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
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
