
variable "uri_pattern" {

}

variable "user_agent" {
    default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
}

variable "description" {
    default = "C2-Filter"
}

variable "referer" {
    default = "NONE"
}

variable "country" {
    default = "US"
}

variable "filter_selection" {
}

variable "worker_name" {
    default = "cf-http-redirector"//won't need to change unless more than one redirector needed
}

variable "zone_id" {
}

variable "my_domain_name" {

}

variable "c2_server" {
    
}

//our default C2 script - just pass request on to target domain
variable "worker_script_content" {
    default = <<-EOF
addEventListener('fetch', event => {
event.respondWith(handleRequest(event.request))
})
/*
* Respond to the request
* @param {Request}
*/
async function handleRequest(request) {
let url = new URL(request.url)
url.hostname = "C2DOMAIN"
return fetch(url, request)
}
EOF
}
