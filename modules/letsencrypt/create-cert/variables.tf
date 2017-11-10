variable domain {}
//variable "godaddy_key" {}
//variable "godaddy_secret" {}

variable "reg_email" {
  default = "nobody@example.com"
}

variable "subject_alternative_names" {
  type = "list"
  default = []
}