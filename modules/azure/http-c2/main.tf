provider "azure" {}

resource "tls_private_key" "ssh" {
  count     = var.count_vm
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.count_vm
  name                = "http-c2-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = var.locations[count.index]
  resource_group_name = var.resource_group_names[count.index]
}

resource "azurerm_subnet" "subnet" {
  count                = var.count_vm
  name                 = "subnet01"
  resource_group_name  = var.resource_group_names[count.index]
  virtual_network_name = element(azurerm_virtual_network.vnet.*.name, count.index)
  address_prefix       = "10.1.0.0/24"
}

resource "azurerm_public_ip" "pip" {
  count                        = var.count_vm
  name                         = "http-c2-pip-${count.index}"
  location                     = var.locations[count.index]
  resource_group_name          = var.resource_group_names[count.index]
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "nic" {
  count                     = var.count_vm
  name                      = "http-c2-nic-${count.index}"
  location                  = var.locations[count.index]
  resource_group_name       = var.resource_group_names[count.index]
  network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)

  ip_configuration {
    name                          = "http-c2-nic-config"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index )
  }
}

resource "azurerm_virtual_machine" "http-c2" {
  count                 = var.count_vm
  name                  = "http-c2-${count.index}"
  location              = var.locations[count.index]
  resource_group_name   = var.resource_group_names[count.index]
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size               = var.size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  # Official Debian images for Azure: https://wiki.debian.org/Cloud/MicrosoftAzure
  storage_image_reference {
    publisher = "credativ"
    offer     = "Debian"
    sku       = "9"
    version   = "latest"
  }

  storage_os_disk {
    name          = "http-c2-${count.index}-os"
    vhd_uri       = "${var.primary_blob_endpoints[count.index]}${var.storage_container_names[count.index]}/http-c2-${count.index}-os.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "http-c2-${count.index}"
    admin_username = var.username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = tls_private_key.ssh.*.public_key_openssh[count.index]
    }
  }

  provisioner "remote-exec" {
    scripts = concat(list("./data/scripts/core_deps.sh"), var.install)

    connection {
      type        = "ssh"
      host        = element(azurerm_public_ip.pip.*.ip_address, count.index )
      user        = var.username
      private_key = tls_private_key.ssh.*.private_key_pem[count.index]
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./data/ssh_keys/${element(azurerm_public_ip.pip.*.ip_address, count.index)} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./data/ssh_keys/${element(azurerm_public_ip.pip.*.ip_address, count.index)}.pub && chmod 600 ./data/ssh_keys/*"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "rm ./data/ssh_keys/${element(azurerm_public_ip.pip.*.ip_address, count.index)}*"
  }
}

resource "null_resource" "ansible_provisioner" {
  count = signum(length(var.ansible_playbook)) == 1 ? var.count_vm : 0

  depends_on = [azurerm_virtual_machine.http-c2]

  triggers = {
    droplet_creation = join("," , azurerm_virtual_machine.http-c2.*.id)
    policy_sha1 = sha1(file(var.ansible_playbook))
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.ansible_arguments))} --user=${var.username} --private-key=./data/ssh_keys/${element(azurerm_public_ip.pip.*.ip_address, count.index)} -e host=${element(azurerm_public_ip.pip.*.ip_address, count.index)} ${var.ansible_playbook}"

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "ssh_config" {

  count    = var.count_vm

  template = file("./data/templates/ssh_config.tpl")

  depends_on = [azurerm_virtual_machine.http-c2]

  vars = {
    name = "dns_c2_${element(azurerm_public_ip.pip.*.ip_address, count.index)}"
    hostname = element(azurerm_public_ip.pip.*.ip_address, count.index)
    user = var.username
    identityfile = path.root}/data/ssh_keys/${element(azurerm_public_ip.pip.*.ip_address, count.index)
  }

}

resource "null_resource" "gen_ssh_config" {

  count = var.count_vm

  triggers = {
    template_rendered = data.template_file.ssh_config.*.rendered[count.index]
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.ssh_config.*.rendered[count.index]}' > ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm ./data/ssh_configs/config_${random_id.server.*.hex[count.index]}"
  }

}
