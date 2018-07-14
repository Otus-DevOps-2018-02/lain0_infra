data "template_file" "reddit_app_puma_service" {
  template = "${file("${path.module}/files/puma.service.tpl")}"

  vars {
    reddit_db_addr = "${var.reddit_db_ip}"
  }
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = "${var.tags}"

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
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

  # provisioner "file" {
  #   # source      = "files/puma.service"
  #   content     = "${data.template_file.reddit_app_puma_service.rendered}"
  #   destination = "/tmp/puma.service"
  # }

  # provisioner "remote-exec" {
  #   script = "${path.module}/files/deploy.sh"
  # }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = "${var.target_tags}"
}
