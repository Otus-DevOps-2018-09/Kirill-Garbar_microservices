terraform {
  backend "gcs" {
    bucket  = "storage-bucket-kornsn-test"
    prefix  = "terraform/state"
    project = "eng-cogency-222612"
  }
}
