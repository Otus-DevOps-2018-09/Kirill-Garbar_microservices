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

variable "cluster_name" {
	default = "standard-cluster-1"
	description = ""
}
variable "cluster_min_ver" {
	default = "1.10.11-gke.1"
	description = ""
}
variable "workers_count" {
	default = "2"
	description = ""
}
variable "workers_mach_type" {
	default = "n1-standard-1"
	description = ""
}
variable "workers_disk_size" {
	default = "20"
	description = ""
}
