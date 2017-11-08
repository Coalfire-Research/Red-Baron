output "ips" {
  value = ["${linode_linode.http-rdir.*.ip_address}"]
}