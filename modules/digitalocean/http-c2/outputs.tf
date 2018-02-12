output "ips" {
  value = ["${digitalocean_droplet.http-c2.*.ipv4_address}"]
}