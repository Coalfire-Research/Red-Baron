//this is your domain
variable "my_domain_name" {
}

variable "zone_id" {

}

//By default we'll make a record for the www A record
variable "hostname" {
    default = "www"
}

variable "type" {
    default = "A"
}

variable "server" {
    default = "1.1.1.1"
}