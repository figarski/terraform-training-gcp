output "vm1_ip" {
  value = google_compute_instance.ginstance_f.network_interface[0].access_config[0].nat_ip
  }