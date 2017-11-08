output "ips" {
  value = ["${aws_instance.dns-c2.*.public_ip}"]
}