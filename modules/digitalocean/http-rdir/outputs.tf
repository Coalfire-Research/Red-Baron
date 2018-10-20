output "ips" {
  value = ["${digitalocean_droplet.http-rdir.*.ipv4_address}"]
}

output "ssh_user" {
  value = "root"
}