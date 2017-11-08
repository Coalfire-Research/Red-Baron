output "ips" {
  value = ["${linode_linode.dns-rdir.*.ip_address}"]
}