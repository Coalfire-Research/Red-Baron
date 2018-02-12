output "ips" {
  value = ["${digitalocean_droplet.http-rdir.*.ipv4_address}"]
}