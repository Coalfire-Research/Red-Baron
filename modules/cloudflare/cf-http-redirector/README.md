# cf-http-rdir

Creates a HTTP payload dropper all in CloudFlare using Worker scripts.
Note: the 

# Example

```hcl
module "http-redirector" {
  source = "./modules/cloudflare/cf-http-redirector"
  zone_id = "${module.zone.zone_id}"

  my_domain_name = "DOMAINNAME"            //our frontend domain
  c2_server = "DESTINATION"                //our backend domain
  uri_pattern = "/agentcallback/*"         //the URI that should be redirected to C2
  filter_selection = "country"            //filter setting (none, country, user_agent, referer, all)
  country = "US"                          //override default filter details
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zone_id`                  | Yes      | String     | Reference to the Zone to host the redirector
|`my_domain_name`           | Yes      | String     | Domain name to use
|`c2_server`                | Yes      | String     | FQDN of our C2 server (CloudFlare refuses IPs)
|`uri_pattern`              | Yes      | String     | URI pattern that will redirect to C2 server
|`filter_selection`         | Yes      | String     | OpSec filter selection (all, country, user_agent, referer)
|`filename`                 | Yes      | String     | Filename to send the client
|`file_content`             | Yes      | String     | Base64 encoded file contents
|`user_agent`               | No       | String     | Override user agent filter (if used)
|`country`                  | No       | String     | Override country filter (if used)
|`referer`                  | No       | String     | Override referer filter (if used)
|`description`              | No       | String     | Override Firewall rule
|`worker_name`              | No       | String     | Override Worker name prefix (cf-http-redirector)
|`worker_script_content`    | No       | String     | Override Worker content (heart of the redirection)

