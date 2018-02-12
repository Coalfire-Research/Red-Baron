variable "install" {
  type = "list"
  default = []
}

variable "count" {
  default = 1
}

variable "size" {
  default = "1gb"
}

variable "regions" {
  type = "list"
  default = ["NYC1"]
}

variable "available_regions" {
  type = "map"
  default = {
    "NYC1" = "nyc1"
    "NYC2" = "nyc2"
    "NYC3" = "nyc3"
    "SFO1" = "sfo1"
    "SFO2" = "sfo2"
    "AMS2" = "ams2"
    "AMS3" = "ams3"
    "SGP1" = "sgp1"
    "LON1" = "lon1"
    "FRA1" = "fra1"
    "TOR1" = "tor1"
    "BLR1" = "blr1"
  }
}