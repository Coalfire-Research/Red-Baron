variable "matching_uri" {
}

//use this variable to tie instances (route and worker) together
//for a given module
variable "worker_name" {
    default = "worker_name"
}

variable "zid" {   
}

variable "worker_script_content" {
    default = "\\test"
}