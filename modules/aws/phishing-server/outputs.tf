output "ips" {
  value = ["${aws_instance.phishing-server.*.public_ip}"]
}