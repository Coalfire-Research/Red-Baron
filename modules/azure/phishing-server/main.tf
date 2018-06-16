provider "azure" {}

resource "tls_private_key" "ssh" {
  count     = "${var.count}"
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_network" "vnet" {
  count               = "${var.count}"
  name                = "phishing-server-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = "${var.locations[count.index]}"
  resource_group_name = "${var.resource_group_names[count.index]}"
}

resource "azurerm_subnet" "subnet" {
  count                = "${var.count}"
  name                 = "subnet01"
  resource_group_name  = "${var.resource_group_names[count.index]}"
  virtual_network_name = "${element(azurerm_virtual_network.vnet.*.name, count.index)}"
  address_prefix       = "10.1.0.0/24"
}

resource "azurerm_public_ip" "pip" {
  count                        = "${var.count}"
  name                         = "phishing-server-pip-${count.index}"
  location                     = "${var.locations[count.index]}"
  resource_group_name          = "${var.resource_group_names[count.index]}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "nic" {
  count                     = "${var.count}"
  name                      = "phishing-server-nic-${count.index}"
  location                  = "${var.locations[count.index]}"
  resource_group_name       = "${var.resource_group_names[count.index]}"
  network_security_group_id = "${element(azurerm_network_security_group.nsg.*.id, count.index)}"

  ip_configuration {
    name                          = "phishing-server-nic-config"
    subnet_id                     = "${element(azurerm_subnet.subnet.*.id, count.index)}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.pip.*.id, count.index )}"
  }
}

resource "azurerm_virtual_machine" "phishing-server" {
  count                 = "${var.count}"
  name                  = "phishing-server-${count.index}"
  location              = "${var.locations[count.index]}"
  resource_group_name   = "${var.resource_group_names[count.index]}"
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size               = "${var.size}"

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
    name          = "phishing-server-${count.index}-os"
    vhd_uri       = "${var.primary_blob_endpoints[count.index]}${var.storage_container_names[count.index]}/phishing-server-${count.index}-os.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "phishing-server-${count.index}"
    admin_username = "${var.username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = "${tls_private_key.ssh.*.public_key_openssh[count.index]}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y tmux apache2 certbot",
      "sudo a2enmod ssl",
      "sudo systemctl stop apache2",
    ]

    connection {
      type        = "ssh"
      host        = "${element(azurerm_public_ip.pip.*.ip_address, count.index )}"
      user        = "${var.username}"
      private_key = "${tls_private_key.ssh.*.private_key_pem[count.index]}"
    }
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ssh.*.private_key_pem[count.index]}\" > ./ssh_keys/phishing_server_${element(azurerm_public_ip.pip.*.ip_address, count.index )} && echo \"${tls_private_key.ssh.*.public_key_openssh[count.index]}\" > ./ssh_keys/phishing_server_${element(azurerm_public_ip.pip.*.ip_address, count.index )}.pub"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "rm ./ssh_keys/phishing_server_${element(azurerm_public_ip.pip.*.ip_address, count.index )}*"
  }
}
