output "ips" {
  value = ["${aws_instance.http-rdir.*.public_ip}"]
}

output "ssh_user" {
  value = "admin"
}