variable "redirect_to" {
  type = "list"
}

variable "count" {
  default = 1
}

variable "ansible_playbook" {
  default = ""
  description = "Ansible Playbook to run"
}

variable "ansible_arguments" {
  default = []
  type    = "list"
  description = "Additional Ansible Arguments"
}

variable "ansible_vars" {
  default = []
  type    = "list"
  description = "Environment variables"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "project" {
  default = "Red-Baron"
}

variable "zones" {
  type = "list"
  default = ["Canada-1"]
}

variable "available_zones" {
  type = "map"
  default = {
    "Canada-1" = "northamerica-northeast1-a"
    "Canada-2" = "northamerica-northeast1-b"
    "Canada-3" = "northamerica-northeast1-c"
    "Iowa-1" = "us-central1-a"
    "Iowa-2" = "us-central1-b"
    "Iowa-3" = "us-central1-c"
    "Iowa-4" = "us-central1-f"
    "Oregon-1" = "us-west1-a"
    "Oregon-2" = "us-west1-b"
    "Oregon-3" = "us-west1-c"
    "Virginia-1" = "us-east4-a"
    "Virginia-2" = "us-east4-b"
    "Virginia-3" = "us-east4-c"
    "South-Carolina-1" = "us-east1-a"
    "South-Carolina-2" = "us-east1-b"
    "South-Carolina-3" = "us-east1-c"
    "South-Carolina-4" = "us-east1-d"
    "Brazil-1" = "southamerica-east1-a"
    "Brazil-2" = "southamerica-east1-b"
    "Brazil-3" = "southamerica-east1-c"
    "Belgium-1" = "europe-west1-b"
    "Belgium-2" = "europe-west1-c"
    "Belgium-3" = "europe-west1-d"
    "UK-1" = "europe-west2-a"
    "UK-2" = "europe-west2-b"
    "UK-3" = "europe-west2-c"
    "Germany-1" = "europe-west3-a" 
    "Germany-2" = "europe-west3-b"
    "Germany-3" = "europe-west3-c"
    "Netherlands-1" = "europe-west4-b"
    "Netherlands-2" = "europe-west4-c"
    "India-1" = "asia-south1-a"
    "India-2" = "asia-south1-b"
    "India-3" = "asia-south1-c"
    "Singapore-1" = "asia-southeast1-a"
    "Singapore-2" = "asia-southeast1-b"
    "Taiwan-1" = "asia-east1-a"
    "Taiwan-2" = "asia-east1-b"
    "Taiwan-3" = "asia-east1-c"
    "Japan-1" = "asia-northeast1-a"
    "Japan-2" = "asia-northeast1-b"
    "Japan-3" = "asia-northeast1-c"
    "Australia-1" = "australia-southeast1-a"
    "Australia-2" = "australia-southeast1-b"
    "Australia-3" = "australia-southeast1-c"
  }
}