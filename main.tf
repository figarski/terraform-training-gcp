terraform {
  required_providers {
    google = {
      source  = "google"
      version = "6.24.0"
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region
}

resource "google_compute_instance" "ginstance_f" {
    name         = var.vm_name
    machine_type = var.vm_type
    zone         = var.vm_zone

  boot_disk {
    initialize_params {
      image = var.vm_os
    }
  }

  attached_disk {
    source = google_compute_disk.gdisk_f.id
  }

  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
    startup-script = file("./start.sh")
  }

  tags = ["http-server"]

}

resource "google_compute_firewall" "gcp_firewall" {
  name = "gcp-firewall-pekao"
  network = "default"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  target_tags = ["http-server"]
}

resource "google_compute_disk" "gdisk_f" {
  name = var.disk_name
  type = var.disk_type
  zone = var.vm_zone
  size = var.disk_size
}
