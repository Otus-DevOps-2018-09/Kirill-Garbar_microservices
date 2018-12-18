variable "source_ranges" {
  type        = "list"
  description = "Allowed IP addresses"

  default = [
    "0.0.0.0/0",
  ]
}
