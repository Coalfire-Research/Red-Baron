output "ips" {
  value = ["${linode_linode.dns-c2.*.ip_address}"]
}