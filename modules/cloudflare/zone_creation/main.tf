//setup our benign CNAME relay. No need to clone

//our overall domain
resource "cloudflare_zone" "target_domain" {
    zone = "${var.my_domain_name}"
    plan = "free"
}

//set the @ record
resource "cloudflare_record" "benign_CNAME" {
    zone_id = "${cloudflare_zone.target_domain.id}"
    name = "${var.my_domain_name}"
    type = "CNAME"
    ttl = "1"
    proxied = "true"
    value = "${var.benign_domain}"
}

//another benign CNAME relay for good measure
resource "cloudflare_record" "benign_www_CNAME" {
    zone_id = "${cloudflare_zone.target_domain.id}"
    name = "${var.cname_record}"
    type = "CNAME"
    ttl = "1"
    proxied = "true"
    value = "${var.benign_domain}"
}

/*
resource "cloudflare_zone_settings_override" "zone_settings_override"{
	zone_id = "${cloudflare_zone.target_domain.id}"
	settings {
		always_online = "off"
		always_use_https = "off"
		automatic_https_rewrites = "on"
		brotli = "on"
		browser_cache_ttl = 1800
		browser_check = "on"
		cache_level = "basic"
		challenge_ttl = 1800
		cname_flattening = "flatten_at_root"
		development_mode = "off"
		edge_cache_ttl = 7200
		email_obfuscation = "on"
		hotlink_protection = "off"
		http2 = "on"
		http3 = "off"
		ip_geolocation = "on"
		ipv6 = "on"
		max_upload = 100
		min_tls_version = "1.0"
		minify {
			css = "off"
			html = "off"
			js = "off"
		}
		
		mobile_redirect {
			mobile_subdomain = ""
			status = "off"
			strip_uri = false
		}
		
		opportunistic_encryption = "on"
		opportunistic_onion = "on"
		privacy_pass = "on"
		pseudo_ipv4 = "off"
		rocket_loader = "off"
		security_header {
			
			enabled = false
			include_subdomains = false
			max_age = 0
			nosniff = false
			preload = false
				
		}
		
		security_level = "medium"
		server_side_exclude = "on"
		sort_query_string_for_cache = "off"
		ssl = "full"
		tls_1_3 = "on"
		tls_client_auth = "off"
		waf = "off"
		websockets = "on"
		zero_rtt = "off"
	}
}
*/
output "zone_id" {
    value = "${cloudflare_zone.target_domain.id}"   
}