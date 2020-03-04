


variable "zone_id" {
}

variable "URI" {
    default = "www"
}

variable "referer" {
    default = "INSERT MOST COMMON UA HERE"
}

variable "UA" {
    default = "INSERT MOST COMMON UA HERE"
}

variable "Country" {
  default = "US"
}

variable "f_types" {
  type = "map"
  default = {
    "none" = "(http.request.uri contains \"URISTRING\")"
    "all" = "(http.request.uri contains \"URISTRING\" and ip.geoip.country ne \"COUNTRYSTRING\") or (http.request.uri contains \"URISTRING\" and http.user_agent ne \"UASTRING\") or (http.request.uri contains \"URISTRING\" and http.referer ne \"REFERERSTRING\")"
    "user_agent" = "(http.request.user_agent contains \"URISTRING\" and http.user_agent ne \"USERAGENTSTRING\")"
    "referer" = "(http.request.uri contains \"URISTRING\" and http.referer ne \"REFERERSTRING\")"
    "country" = "(http.request.uri contains \"URISTRING\" and ip.geoip.country ne \"COUNTRYSTRING\")"
  }
}

output "filter_string" {
  value = "${lookup(var.f_types,var.filter_selection,"none")}"
}

variable "filter_selection" {
  default = "country"
}

output "filter_id" {
  value = "${cloudflare_filter.filter.id}"
}