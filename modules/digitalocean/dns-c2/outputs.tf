output "ips" {
  value = ["${digitalocean_droplet.dns-c2.*.ipv4_address}"]
}