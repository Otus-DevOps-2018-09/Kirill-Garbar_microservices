provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}
