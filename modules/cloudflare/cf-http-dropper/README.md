# cf-http-dropper

Creates a HTTP payload dropper all in CloudFlare using Worker scripts.

# Example

```hcl
module "http-dropper" {
  source = "./modules/cloudflare/cf-http-dropper"
  zone_id = "${module.zone.zone_id}"
  
  my_domain_name = "DOMAINNAME"             //our frontend domain
  uri_pattern = "/downloads/*"              //the URI that should be redirected to a payload
  filter_selection = "country"              //filter map setting
  filename = "test.bat"                     //filename to present to user
  file_content = "aGVsbG8gd29ybGQ="         //Base64 encoded payload (hello world)
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zone_id`                  | Yes      | String     | Reference to the Zone to host the redirector
|`my_domain_name`           | Yes      | String     | Domain name to use
|`uri_pattern`              | Yes      | String     | URI pattern that will redirect to the payload
|`filter_selection`         | Yes      | String     | OpSec filter selection (all, country, user_agent, referer)
|`filename`                 | Yes      | String     | Filename to send the client
|`file_content`             | Yes      | String     | Base64 encoded file contents
|`user_agent`               | No       | String     | Override user agent filter (if used)
|`country`                  | No       | String     | Override country filter (if used)
|`referer`                  | No       | String     | Override referer filter (if used)
|`description`              | No       | String     | Override Firewall rule
|`visit_action`             | No       | String     | Override Firewall action (block or captcha)
|`worker_name`              | No       | String     | Override Worker name prefix (cf-http-redirector)
|`worker_script_content`    | No       | String     | Override Worker content (heart of the redirection)
