output "records" {
  value = "${zipmap(var.domains, var.data)}"
}