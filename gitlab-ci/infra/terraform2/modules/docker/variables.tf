variable "zone" {
  default     = "europe-west1-b"
  description = "zone for VM"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable docker_disk_image {
  description = "Disk image for vm"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "provisioner_condition" {
  description = "if it's equal 1, then exec provisioner"
  default = "0"
}

variable "docker_count" {
  description = "instances quantity for LB"
  default     = "1"
}

variable "tags" {
  type = "list"
  description = "tags for instance"
  default = [""]
}

variable "default_tags" {
  type = "list"
  description = "default tags"
  default = ["docker-host"]
}

variable "machine_name" {
  default = "docker"
  description = "machine name"
}

variable "machine_type" {
  description = "machine type in GCP"
  default = "f1-micro"
  # n1-standard-1
}

variable "var_static_ip" {
  default = false
}
