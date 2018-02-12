output "ips" {
  value = ["${digitalocean_droplet.phishing-server.*.ipv4_address}"]
}