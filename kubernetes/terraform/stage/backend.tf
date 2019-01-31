terraform {
  backend "gcs" {
    bucket = "storage-bucket-docker-223709-stage"
    prefix = "stage"
  }
}
