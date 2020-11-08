

resource "random_id" "firewall_rule" {
    keepers = {
        #Generate a new id each time we switch to a new worker name
        name = "${var.description}"
    }
    byte_length = 8
}

resource "cloudflare_firewall_rule" "firewall_rule_agent" {
  zone_id = "${var.zone_id}"
  description = "${var.description}_${random_id.firewall_rule.hex}"
  filter_id = "${var.f_id}"
  action = "${var.action}"//challenge or block
  //priority = 1000//sets the order - higher is lower, but shouldn't need this if URI matches differ
}