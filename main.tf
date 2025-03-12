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
    startup-script = join(" ",[templatefile("/home/student/terraform/git/terraform-warsztat/terraform-training-gcp/script.sh", {disk_name = var.disk_name, disk_id = google_compute_disk.gdisk_f.id}),file("/home/student/terraform/git/terraform-warsztat/terraform-training-gcp/start.sh")])
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

resource "google_compute_resource_policy" "gcp_policy_f" {
  name = "polityka-${var.disk_name}"
  region = var.region
  snapshot_schedule_policy {
    retention_policy {
      max_retention_days = 7
    }
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time = "04:00"
      }
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "attach_policy_f" {
  disk = google_compute_disk.gdisk_f.name
  zone = var.vm_zone
  name = google_compute_resource_policy.gcp_policy_f.name
}