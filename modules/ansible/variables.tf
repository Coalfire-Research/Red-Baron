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
  type    = list(string)
  description = "Arguments"
}

variable "envs" {
  default = []
  type    = list(string)
  description = "Environment variables"
}

/*
variable "dry_run" {
  default = true
  description = "Do dry run"
}
*/