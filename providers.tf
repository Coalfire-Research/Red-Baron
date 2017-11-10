provider "linode" {
  key = "${var.linode_key}"
}

provider "godaddy" {
  key = "${var.godaddy_key}"
  secret = "${var.godaddy_secret}"
}

provider "aws" {
  access_key = "${var.aws_akey}"
  secret_key = "${var.aws_skey}"
  region = "${var.aws_region}"
}

/*
// Initialize a provider for each available AWS region
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

provider "aws" {
  alias  = "sa-east-1"
  region = "sa-east-1"
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "ca-central-1"
  region = "ca-central-1"
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "ap-northeast-1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "ap-south-1"
  region = "ap-south-1"
}
*/