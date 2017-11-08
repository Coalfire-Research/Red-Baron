provider "linode" {
  key = "${var.linode_key}"
}

provider "aws" {
  access_key = "${var.aws_akey}"
  secret_key = "${var.aws_skey}"
  region = "${var.aws_region}"
}

provider "godaddy" {
  key = "${var.godaddy_key}"
  secret = "${var.godaddy_secret}"
}