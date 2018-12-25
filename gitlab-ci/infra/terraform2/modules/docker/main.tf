resource "google_compute_instance" "docker" {
  name         = "${var.machine_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = "${concat(var.tags, var.default_tags)}"

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${var.var_static_ip ? "" : "${google_compute_address.static_ip.address}"}"
      }



  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}


resource "google_compute_address" "static_ip" {
  name = "docker-static-ip"
  
}
