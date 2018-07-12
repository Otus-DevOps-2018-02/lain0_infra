variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable bucket_name {
  description = "GCP backends bucket name"
  default     = ["storage-bucket-lain0_reddit-prod", "storage-bucket-lain0_reddit-stage"]
}
