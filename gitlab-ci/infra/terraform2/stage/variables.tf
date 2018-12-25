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

variable docker_disk_image {
  description = "Disk image for reddit app"
}

variable "gitlab_tags" {
  type = "list"
  description = "tags for instance"
  default = [""]
}

variable "runner_tags" {
  type = "list"
  description = "tags for instance"
  default = [""]
}

variable "machine_name_gitlab" {
  description = "gitlab machine name"
}

variable "machine_name_runner" {
  description = "runner machine name"
}

variable "gitlab_var_static_ip" {
  default = true
}
