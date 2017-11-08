output "dns-rdir-domain" {
  value = "${var.ns_record_name}.${var.domain}"
}