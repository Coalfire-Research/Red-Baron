output "ips" {
  value = ["${linode_linode.http-c2.*.ip_address}"]
}