variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  default     = "europe-west1-b"
  description = "zone for VM"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for ssh access"
}

# variable disk_image {
#   description = "Disk image"
# }

variable "app_count" {
  description = "instances quantity for LB"
  default     = "1"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "provisioner_condition" {
  description = "if it's equal 1, then exec provisioner"
}
