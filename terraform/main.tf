provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source           = "modules/app"
  public_key_path  = "${var.public_key_path}"
  privite_key_path = "${var.privite_key_path}"
  zone             = "${var.zone}"
  project          = "${var.project}"
  app_disk_image   = "${var.app_disk_image}"
  reddit_db_ip     = "${module.db.reddit_db_ip}"
}

module "db" {
  source           = "modules/db"
  public_key_path  = "${var.public_key_path}"
  privite_key_path = "${var.privite_key_path}"
  zone             = "${var.zone}"
  project          = "${var.project}"
  db_disk_image    = "${var.db_disk_image}"
}

module "vpc" {
  source        = "modules/vpc"
  source_ranges = ["80.250.215.124/32", "109.172.15.33/32"]
}
