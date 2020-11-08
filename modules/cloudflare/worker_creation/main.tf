//WORKER SCRIPT CREATION IS BROKEN.
//USE THE DEPLOY SCRIPT TO GENERATE THE WORKER SCRIPT
//WITH MATCHING VARIABLES FROM THIS MODULE.

//	* cloudflare_worker_script.worker_script: error creating worker script: account ID required for enterprise only request

resource "random_id" "worker_script" {
    keepers = {
        #Generate a new id each time we switch to a new worker name
        name = "${var.worker_name}"
    }
    byte_length = 8
}

resource "cloudflare_worker_script" "worker_script" {
	name = "${var.worker_name}_${random_id.worker_script.hex}"
    content = "${var.worker_script_content}"
}

resource "cloudflare_worker_route" "worker_request" {

    pattern = "${var.matching_uri}"
	zone_id = "${var.zid}"
	script_name = "${var.worker_name}_${random_id.worker_script.hex}"
}

