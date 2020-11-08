# worker_creation

Creates a CloudFlare Worker Route and Worker Script
Note that the matching URI accepts wildcards.

matching_uri example: `*.example.com\blah*` would match requests CloudFlare handles for all subdomains of example.com that also are requesting a URI that begins with `blah`.

# Example

```hcl
module "worker-route" {
  source = "../worker_creation"
  matching_uri = "${format("%s%s",var.my_domain_name, var.uri_pattern)}"
  worker_name = "${var.worker_name}"
  worker_script_content = "${replace(var.worker_script_content,"C2DOMAIN",var.c2_server)}"
  zid = "${var.zone_id}"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zid`                      | Yes      | String     | Reference to the Zone to host the redirector
|`matching_uri`             | Yes      | String     | URI Pattern to match (use * wildcard)
|`worker_name`              | Yes      | String     | Worker name to use, will append a unique value
|`worker_script_content`    | Yes      | String     | Worker script content
