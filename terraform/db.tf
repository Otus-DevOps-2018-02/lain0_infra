resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  # add user/sshkey for provisioner
  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.privite_key_path)}"
  }

  provisioner "file" {
    source      = "files/mongod.conf"
    destination = "/tmp/mongod.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/mongod.conf /etc/mongod.conf && sudo systemctl restart mongod",
    ]

    # script = "files/mongo-bind.sh"
  }
}

# access to DB for instance tagged reddit-app
resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # правило применимо к инстансам с тегом ...
  target_tags = ["reddit-db"]

  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["reddit-app"]
}
