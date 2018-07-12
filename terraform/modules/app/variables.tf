variable project {
  description = "Project ID"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable machine_type {
  description = "Machine type"
  default     = "g1-small"
}

variable target_tags {
  # target_tags
  description = "target_tags"
  default     = ["reddit-app"]
}

variable tags {
  # target_tags
  description = "target_tags"
  default     = ["reddit-app"]
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable privite_key_path {
  description = "Privite ssh-key provisioner path"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable reddit_db_ip {
  description = "reddit-db-internal-ip"
}
