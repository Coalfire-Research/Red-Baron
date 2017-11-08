output "ips" {
  value = ["${aws_instance.http-c2.*.public_ip}"]
}