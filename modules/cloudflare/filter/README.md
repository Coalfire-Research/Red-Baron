# filter

Creates a filter to be assigned to a CloudFlare firewall rule

# Example

```hcl
module "http-filter-name" {
  source = "../filter"
  zone_id = "${var.zone_id}"
  URI = "${var.uri_pattern}"
  UA = "${var.user_agent}"
  referer = "${var.referer}"
  filter_selection = "${var.filter_selection}"
}
```

# Arguments

| Name                      | Required | Value Type | Description
|---------------------------| -------- | ---------- | -----------
|`zone_id`                  | Yes      | String     | Reference to the Zone to host the redirector
|`URI`                      | No       | String     | Matching URI pattern to match
|`UA`                       | No       | String     | URI pattern that will redirect to the first payload
|`Country`                  | No       | String     | Override country filter (if used)
|`referer`                  | No       | String     | Override referer filter (if used)

# Outputs

| Name                      | Value Type | Description
|---------------------------| ---------- | -----------
|`filter_id`                | Int        | Used by Firewall Rules to reference the filter
|`filter_string`            | String     | String containing the mapped filter selection
|`f_types`                  | Map        | Map of potential firewall filter sets and the rule strings
