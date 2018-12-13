variable "zone" {
  default     = "europe-west1-b"
  description = "zone for VM"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-docker"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

variable "provisioner_condition" {
  description = "if it's equal 1, then exec provisioner"
}

variable "app_count" {
  description = "instances quantity for LB"
  default     = "1"
}
