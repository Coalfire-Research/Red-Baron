output "ips" {
  value = ["${linode_linode.dns-c2.*.ip_address}"]
}

output "ssh_user" {
  value = "root"
}