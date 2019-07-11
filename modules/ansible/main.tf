terraform {
  required_version = ">= 0.11.0"
}

resource "null_resource" "ansible_provisioner" {

  triggers {
    policy_sha1 = "${sha1(file(var.playbook))}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.arguments))} --user=${var.user} --private-key=./data/ssh_keys/${var.ip} -e host=${var.ip}${join(" -e ", compact(var.envs))} ${var.playbook}"

    environment {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}