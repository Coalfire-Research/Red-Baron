# cf-http-stager

Proof-of-concept code for a Worker that sends a multi-request JSON response for an implant (code not created yet) using a combination of the other cf modules.
Note that the second stage request must be a POST as currently configured in the worker script for an example of using different validation checks between payload requests.

# Example

```hcl
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
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zone_id`                  | Yes      | String     | Reference to the Zone to host the redirector
|`my_domain_name`           | Yes      | String     | Domain name to use
|`first_stage_uri_pattern`  | Yes      | String     | URI pattern that will redirect to the first payload
|`second_stage_uri_pattern` | Yes      | String     | URI pattern that will redirect to the second payload
|`filter_selection`         | Yes      | String     | OpSec filter selection (all, country, user_agent, referer)
|`first_stage_json`         | Yes      | String     | JSON response to return for a valid first stage request
|`second_stage_json`        | Yes      | String     | JSON response to return for a valid second stage request
|`user_agent`               | No       | String     | Override user agent filter (if used)
|`country`                  | No       | String     | Override country filter (if used)
|`referer`                  | No       | String     | Override referer filter (if used)
|`description`              | No       | String     | Override Firewall rule
|`worker_name`              | No       | String     | Override Worker name prefix (cf-http-redirector)
|`worker_script_content`    | No       | String     | Override Worker content (heart of the redirection)
