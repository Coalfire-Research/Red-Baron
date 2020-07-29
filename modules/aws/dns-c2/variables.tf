variable "subnet_id" {}

variable "vpc_id" {}

variable "count_vm" {
  default = 1
}

variable "ansible_playbook" {
  default = ""
  description = "Ansible Playbook to run"
}

variable "ansible_arguments" {
  default = []
  type    = list(string)
  description = "Additional Ansible Arguments"
}

variable "ansible_vars" {
  default = []
  type    = list(string)
  description = "Environment variables"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "install" {
  type = list(string)
  default = []
}

/*
variable "install" {
  type = map(string)
  default = {
    "empire" = "./data/scripts/install_empire.sh"
    "metasploit" = "./data/scripts/install_metasploit.sh"
    "cobaltstrike" = "./data/scripts/install_cobalt_strike.sh"
  }
}
*/

variable "amis" {
  type = map(string)
  default = {

    // Taken from https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch
    "ap-northeast-1" = "ami-b6b568d0"
    "ap-northeast-2" = "ami-b7479dd9"
    "ap-south-1" = "ami-02aded6d"
    "ap-southeast-1" = "ami-d76019b4"
    "ap-southeast-2" = "ami-8359bae1"
    "ca-central-1" = "ami-3709b053"
    "eu-central-1" = "ami-8bb70be4"
    "eu-west-1" = "ami-ce76a7b7"
    "eu-west-2" = "ami-a6f9ebc2"
    "sa-east-1" = "ami-f5c7b899"
    "us-east-1" = "ami-71b7750b"
    "us-east-2" = "ami-dab895bf"
    "us-west-1" = "ami-58eedd38"
    "us-west-2" = "ami-c032f6b8"

  }
}