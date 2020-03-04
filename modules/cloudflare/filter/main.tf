resource "cloudflare_filter" "filter" {
  zone_id = var.zone_id
  description = ""
  expression = "${replace(replace(replace(replace("${lookup(var.f_types,var.filter_selection,"na")}", "URISTRING", var.URI), "UASTRING", var.UA), "COUNTRYSTRING", var.Country), "REFERERSTRING", var.referer)}"
}

