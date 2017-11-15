output "ips" {
  value = ["${linode_linode.phishing-server.*.ip_address}"]
}