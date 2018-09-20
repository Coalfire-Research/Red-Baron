terraform {
  required_version = ">= 0.11.0"
}

resource "null_resource" "ansible_provisioner" {
  count = "${length(var.ips)}"

  triggers {
    policy_sha1 = "${sha1(file(var.playbook))}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook ${join(" ", compact(var.arguments))} --user=${var.user} --private-key=./data/ssh_keys/${element(var.ips, count.index)} -e host=${element(var.ips, count.index)}${join(" -e ", compact(var.envs))} ${var.playbook}"

    environment {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}