//this is your domain
variable "my_domain_name" {
}


//This is the domain where redirection should
//send requests that aren't matching either your
//agents or other filters
variable "benign_domain" {
}

//By default we'll make a record for the www A record
//that points to your benign_domain.
variable "cname_record" {
    default = "www"
}

