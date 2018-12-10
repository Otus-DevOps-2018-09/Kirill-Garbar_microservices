provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "docker-gitlab" {
  source          = "../modules/docker"
  public_key_path = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone            = "${var.zone}"
  docker_disk_image  = "${var.docker_disk_image}"
  tags = "${var.gitlab_tags}"
  machine_name = "${var.machine_name_gitlab}"
  var_static_ip = "${var.gitlab_var_static_ip}"
}

module "docker-runner" {
  source          = "../modules/docker"
  public_key_path = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  zone            = "${var.zone}"
  docker_disk_image  = "${var.docker_disk_image}"
  tags = "${var.runner_tags}"
  machine_name = "${var.machine_name_runner}"
}
