variable "playbook" {
  description = "Playbook to run"
}

variable "ip" {
  description = "Host to run playbook on"
}

variable "user" {
  default = "root"
  description = "User to authenticate as"
}

variable "arguments" {
  default = []
  type    = "list"
  description = "Arguments"
}

variable "envs" {
  default = []
  type    = "list"
  description = "Environment variables"
}

/*
variable "dry_run" {
  default = true
  description = "Do dry run"
}
*/