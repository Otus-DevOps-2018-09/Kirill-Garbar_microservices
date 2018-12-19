resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  tags = [
    "reddit-app",
  ]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

# provision
resource "null_resource" "deploy_app" {
  count = "${var.do_deploy ? 1: 0}"

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
  }

  provisioner "file" {
    content     = "${data.template_file.puma_service.rendered}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

data template_file puma_service {
  template = "${file("${path.module}/files/puma.service")}"

  vars {
    db_address = "${var.db_address}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"

    ports = [
      "9292",
    ]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]

  target_tags = [
    "reddit-app",
  ]
}

resource "google_compute_firewall" "firewall_http" {
  name    = "allow-http-default"
  network = "default"

  allow {
    protocol = "tcp"

    ports = [
      "80",
    ]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]

  target_tags = [
    "reddit-app",
  ]
}
