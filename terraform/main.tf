provider "google" {
  version = "1.4.0"
  project = "infra-198609"
  region = "europe-west1"
}

resource "google_compute_instance" "app" {
  name = "reddit-app-terraform"
  machine_type = "f1-micro"
  zone = "europe-west1-b"
  tags = ["reddit-app"]
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "reddit-base"
    }
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  metadata {
    ssh-keys = "appuser:${file("~/.ssh/gcp/appuser.pub")}"
  }
  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  # add user/sshkey for provisioner
  connection {
    type = "ssh"
    user = "appuser"
    agent = false
    private_key = "${file("~/.ssh/gcp/appuser")}"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с тегом ...
  target_tags = ["reddit-app"]
}
