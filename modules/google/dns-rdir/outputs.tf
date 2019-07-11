output "ips" {
  value = ["${google_compute_instance.http-rdir.*.network_interface.0.access_config.0.assigned_nat_ip}"]
}

output "ssh_user" {
  value = "root"
}