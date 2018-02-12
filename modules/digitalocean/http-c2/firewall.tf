terraform {
  required_version = ">= 0.10.0"
}

data "external" "get_public_ip" {
  program = ["bash", "./scripts/get_public_ip.sh" ]
}

resource "digitalocean_firewall" "web" {
  name = "http-c2-only-allow-dns-http-ssh"

  droplet_ids = ["${digitalocean_droplet.http-c2.*.id}"]

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