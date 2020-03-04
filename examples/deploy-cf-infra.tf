// Minimum required TF version is 0.11.0
/*
===================================================================================================
EXAMPLE RED BARON CLOUDFLARE MODULE USAGE

cloudflare/zone_creation : Creates a DNS zone and proxied CNAME records to benign downstream domain
cloudflare/cf-http-dropper : Creates OpSec filters and a worker script to serve a payload download
                             using a base-64 encoded string of the file contents.
cloudflare/cf-http-redirector : Creates OpSec filters and a worker script to redirect traffic to a
                                C2 server (must be name not IP).
                                Note: Ensure the C2 server only allows inbound traffic from CloudFlare IPs
cloudflare/cf-http-stager : Proof-of-concept module serving a multi-response JSON payload. Implant will need
                            to make initial and subsequent requests to combine and execute the payload.
===================================================================================================

INFORMATION FOR BLOCKING ALL IPs EXCEPT CLOUDFLARE SOURCES TO C2 NODES:

Cloudflare IPs for inbound .htaccess
grabbed from https://www.cloudflare.com/ips-v4 <- should pull this dynamically
then create a aws-security group for allowed inbound on http-c2 (or http-rdir)
173.245.48.0/20
103.21.244.0/22
103.22.200.0/22
103.31.4.0/22
141.101.64.0/18
108.162.192.0/18
190.93.240.0/20
188.114.96.0/20
197.234.240.0/22
198.41.128.0/17
162.158.0.0/15
104.16.0.0/12
172.64.0.0/13
131.0.72.0/22

https://www.linode.com/docs/web-servers/apache/how-to-set-up-htaccess-on-apache/#allow-ips
Create or edit the .htaccess file located in the web directory where you want this setting to be applied.

Add the following lines to deny all IPs except for the specific IP and pool of IPs mentioned in the command:

/var/www/html/example.com/public_html
order deny,allow
# Denies all IP's
Deny from all
# This will allow the IP 192.0.2.9
allow from 192.0.2.9
# This will allow all IP's from 192.0.2.0 through 192.0.2.255
allow from 192.0.2
===================================================================================================
*/

terraform {
  required_version = ">= 0.11.0"
}

module "zone" {
  source = "./modules/cloudflare/zone_creation"
  my_domain_name = "DOMAINNAME"            //our frontend domain
  benign_domain = "google.com"                   //the benign domain where non-agents, targets, should be redirected
  cname_record = "www"
  //you'll need this: ${module.zone.zone_id}
}

module "http-redirector" {
  source = "./modules/cloudflare/cf-http-redirector"
  zone_id = "${module.zone.zone_id}"

  my_domain_name = "DOMAINNAME"            //our frontend domain
  c2_server = "DESTINATION"                //the backend C2 server
  uri_pattern = "/agentcallback/*"         //the URI that should be redirected to C2
  filter_selection = "country"            //filter setting (none, country, user_agent, referer, all)
  country = "US"                          //override default filter details
}

module "http-dropper" {
  source = "./modules/cloudflare/cf-http-dropper"
  zone_id = "${module.zone.zone_id}"
  
  my_domain_name = "DOMAINNAME"             //our frontend domain
  uri_pattern = "/downloads/*"              //the URI that should be redirected to a payload
  filter_selection = "country"              //filter map setting
  filename = "test.bat"                     //filename to present to user
  file_content = "aGVsbG8gd29ybGQ="         //Base64 encoded payload (hello world)
}


module "http-stager" {
  source = "./modules/cloudflare/cf-http-stager"
  zone_id = "${module.zone.zone_id}"
  my_domain_name = "DOMAINNAME" //our frontend domain
 
  first_stage_uri_pattern = "/stage1/*"       //the URI that should be redirected to first payload
  second_stage_uri_pattern = "/stage2/*"      //the URI that should be redirected to the second payload
  filter_selection = "country"                //filter map setting
  first_stage_json = "{\"data\":\"blah\"}"    //json payload
  second_stage_json = "{\"data\":\"blah\"}"   //json payload
}