output "ips" {
  value = ["${google_compute_instance.http-rdir.*.network_interface.0.access_config.0.nat_ip}"]
}
