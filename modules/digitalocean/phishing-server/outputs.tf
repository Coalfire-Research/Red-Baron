output "ips" {
  value = ["${digitalocean_droplet.phishing-server.*.ipv4_address}"]
}

output "ssh_user" {
  value = "root"
}