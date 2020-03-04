terraform {
  required_version = ">= 0.11.0"
}



//Need Filter --> Firewall Rule
module "http-filter-stage1" {
  source = "../filter"
  zone_id = "${var.zone_id}"
  URI = "${var.first_stage_uri_pattern}"
  UA = "${var.user_agent}"
  referer = "${var.referer}"
  filter_selection = "${var.filter_selection}"
}

module "http-firewall-stage1" {
  source = "../firewall_rule"
  zone_id = "${var.zone_id}"
  description = "${var.description}"
  f_id = "${module.http-filter-stage1.filter_id}"
  action = "block"
}

module "http-filter-stage2" {
  source = "../filter"
  zone_id = "${var.zone_id}"
  URI = "${var.second_stage_uri_pattern}"
  UA = "${var.user_agent}"
  referer = "${var.referer}"
  filter_selection = "${var.filter_selection}"
}

module "http-firewall-stage2" {
  source = "../firewall_rule"
  zone_id = "${var.zone_id}"
  description = "${var.description}"
  f_id = "${module.http-filter-stage2.filter_id}"
  action = "block"
}

//Then worker route and finally a script to do the redirection
//make sure we name the script the same in deploy.
module "worker-route-stage1"{
  source = "../worker_creation"
  matching_uri = "${format("%s%s",var.my_domain_name, var.first_stage_uri_pattern)}"
  worker_name = "${var.worker_name}1"
  worker_script_content = "${replace(replace(replace(replace(var.worker_script_content,"FIRSTSTAGE",var.first_stage_uri_pattern),"SECONDSTAGE",var.second_stage_uri_pattern),"SOMEJSON1",var.first_stage_json),"SOMEJSON2",var.second_stage_json)}"
  zid = "${var.zone_id}"
}

//same worker script handles both as it checks self-generated hand-off
module "worker-route-stage2"{
  source = "../worker_creation"
  matching_uri = "${format("%s%s",var.my_domain_name, var.second_stage_uri_pattern)}"
  worker_name = "${var.worker_name}2"
  worker_script_content = "${replace(replace(replace(replace(var.worker_script_content,"FIRSTSTAGE",var.first_stage_uri_pattern),"SECONDSTAGE",var.second_stage_uri_pattern),"SOMEJSON1",var.first_stage_json),"SOMEJSON2",var.second_stage_json)}"
  zid = "${var.zone_id}"
}