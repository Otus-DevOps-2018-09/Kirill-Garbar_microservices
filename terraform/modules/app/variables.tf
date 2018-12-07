variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_address {
  description = "Address of database"
  default     = "localhost"
}

variable do_deploy {
  description = "Deploy or not deploy, that's the question"
  default     = false
}
