# firewall_rule

Creates a CloudFlare firewall rule

# Example

```hcl
module "http-firewall" {
  source = "../firewall_rule"
  zone_id = "${var.zone_id}"
  description = "${var.description}"
  f_id = "${module.http-filter.filter_id}"
  action = "block"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zone_id`                  | Yes      | String     | Reference to the Zone to host the redirector
|`description`              | Yes      | String     | Firewall rule name
|`f_id`                     | Yes      | String     | CloudFlare Filter ID containing the rule logic
|`action`                   | No       | String     | Override the default action (Block vs captcha)
