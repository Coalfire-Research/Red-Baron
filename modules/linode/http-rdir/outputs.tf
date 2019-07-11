output "ips" {
  value = ["${linode_linode.http-rdir.*.ip_address}"]
}

output "ssh_user" {
  value = "root"
}