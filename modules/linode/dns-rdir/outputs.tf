output "ips" {
  value = ["${linode_linode.dns-rdir.*.ip_address}"]
}

output "ssh_user" {
  value = "root"
}