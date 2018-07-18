terraform {
  backend "gcs" {
    bucket = "storage-bucket-lain0_reddit-prod"
    prefix = "terraform/state"
  }
}
