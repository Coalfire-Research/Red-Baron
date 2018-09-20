terraform {
  required_version = ">= 0.11.0"
}

provider "google" {
  project = "${var.project}"
}

resource "tls_private_key" "ssh" {
  count = "${var.count}"
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "random_id" "server" {
  count = "${var.count}"
  byte_length = 4
}

resource "google_compute_instance" "dns-c2" {
  count = "${var.count}"
  machine_type = "${var.machine_type}"
  name = "dns-c2-${random_id.server.*.hex[count.index]}"
  zone = "${var.available_zones[element(var.zones, count.index)]}"
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  
  provisioner "remote-exec" {
    scripts = "${concat(list("./scripts/core_deps.sh"), var.install)}"

    connection {
      type = "ssh"
      user = "root"
      private_key = "${tls_private_key.ssh.*.private_key_pem[count.index]}"
    }
  }

  metadata_startup_script = <<SCRIPT
  sed 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config > temp.txt
  mv -f temp.txt /etc/ssh/sshd_config
  service ssh restart
  SCRIPT

  service_account {
    scopes = ["compute-rw"]
  }

  metadata {
    sshKeys = "root:${tls_private_key.ssh.*.public_key_openssh[count.index]}"
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./ssh_keys/dns_rdir_${self.network_interface.0.access_config.0.assigned_nat_ip } && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./ssh_keys/dns_rdir_${self.network_interface.0.access_config.0.assigned_nat_ip}.pub" 
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./ssh_keys/dns_rdir_${self.network_interface.0.access_config.0.assigned_nat_ip}*"
  }
}
