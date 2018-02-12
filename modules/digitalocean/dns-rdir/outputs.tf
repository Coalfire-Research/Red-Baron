output "ips" {
  value = ["${digitalocean_droplet.dns-rdir.*.ipv4_address}"]
}