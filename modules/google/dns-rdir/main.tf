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

resource "google_compute_instance" "dns-rdir" {
  count = "${var.count}"
  machine_type = "${var.machine_type}"
  name = "dns-rdir-${random_id.server.*.hex[count.index]}"
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
    inline = [
      "apt-get update",
      "apt-get install -y tmux socat mosh",
      "tmux new -d \"socat udp4-recvfrom:53,reuseaddr,fork udp4-sendto:${element(var.redirect_to, count.index)}\""
    ]

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
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./data/ssh_keys/${self.network_interface.0.access_config.0.assigned_nat_ip} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./data/ssh_keys/${self.network_interface.0.access_config.0.assigned_nat_ip}.pub && chmod 600 ./data/ssh_keys/*" 
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./data/ssh_keys/${self.network_interface.0.access_config.0.assigned_nat_ip}*"
  }
}

resource "null_resource" "ansible_provisioner" {
  count = "${signum(length(var.ansible_playbook)) == 1 ? var.count : 0}"

  depends_on = ["google_compute_instance.dns-rdir"]

  triggers {
    droplet_creation = "${join("," , google_compute_instance.dns-rdir.*.id)}"
    policy_sha1 = "${sha1(file(var.ansible_playbook))}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.ansible_arguments))} --user=root --private-key=./data/ssh_keys/${google_compute_instance.dns-rdir.*.network_interface.0.access_config.0.assigned_nat_ip[count.index]} -e host=${google_compute_instance.dns-rdir.*.network_interface.0.access_config.0.assigned_nat_ip[count.index]} ${var.ansible_playbook}"

    environment {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "ssh_config" {

  count    = "${var.count}"

  template = "${file("./data/templates/ssh_config.tpl")}"

  depends_on = ["google_compute_instance.dns-rdir"]

  vars {
    name = "dns_c2_${google_compute_instance.dns-rdir.*.network_interface.0.access_config.0.assigned_nat_ip[count.index]}"
    hostname = "${google_compute_instance.dns-rdir.*.network_interface.0.access_config.0.assigned_nat_ip[count.index]}"
    user = "root"
    identityfile = "${path.root}/data/ssh_keys/${google_compute_instance.dns-rdir.*.network_interface.0.access_config.0.assigned_nat_ip[count.index]}"
  }
}

resource "null_resource" "gen_ssh_config" {

  count = "${var.count}"

  triggers {
    template_rendered = "${data.template_file.ssh_config.*.rendered[count.index]}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.ssh_config.*.rendered[count.index]}' > ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

}