terraform {
 required_version = "~>0.11.7"
}

provider "google" {
  version = "2.0.0"

  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata_item" "default" {
  key = "ssh-keys"
  value = "alexmar:${file(var.public_key_path)}"
}


resource "google_compute_instance" "app" {
  count = "${var.node_count}"
  name         = "docker-app${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["docker-app"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  connection {
    type  = "ssh"
    user  = "alexmar"
    agent = false

  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["docker-app"]
}
