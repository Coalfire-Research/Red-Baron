output "ips" {
  value = ["${aws_instance.dns-rdir.*.public_ip}"]
}