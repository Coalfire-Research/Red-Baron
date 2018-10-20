output "ips" {
  value = ["${linode_linode.http-c2.*.ip_address}"]
}

output "ssh_user" {
  value = "root"
}