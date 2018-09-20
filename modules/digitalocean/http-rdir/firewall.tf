terraform {
  required_version = ">= 0.11.0"
}

data "external" "get_public_ip" {
  program = ["bash", "./data/scripts/get_public_ip.sh" ]
}

resource "random_id" "firewall" {
  byte_length = 4
}

resource "digitalocean_firewall" "web" {
  name = "http-rdir-only-allow-dns-http-ssh-${random_id.firewall.hex}"

  droplet_ids = ["${digitalocean_droplet.http-rdir.*.id}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["${data.external.get_public_ip.result["ip"]}/32"]
    },
    {
      protocol         = "udp"
      port_range       = "60000-61000"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]

  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "53"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "53"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "tcp"
      port_range            = "443"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "tcp"
      port_range            = "80"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}
