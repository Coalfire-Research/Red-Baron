# Red Baron

<p align="center">
  <img src="https://orig00.deviantart.net/5aae/f/2016/085/0/5/bloody_baron_by_synestesi_art-d9wjp94.jpg" width="400" height="600" alt="baron"/>
</p>


Red Baron is a set of [modules](https://www.terraform.io/docs/modules/index.html) and custom/third-party providers for [Terraform](https://www.terraform.io/) which tries to automate creating resilient, disposable, secure and agile infrastructure for Red Teams.

# Third-party Providers

This repository comes with a few pre-compiled [Terraform](https://www.terraform.io/) plugins (you can find them under the ```terraform.d``` directory), some of these have been modified to better suit the tool:

- Linode Provider: https://github.com/LinodeContent/terraform-provider-linode
- GoDaddy Provider: https://github.com/n3integration/terraform-godaddy

# Author and Acknowledgments

Author: Marcello Salvati ([@byt3bl33d3r](https://twitter.com/byt3bl33d3r))

The initial inspiration for this came from [@_RastaMouse's](https://twitter.com/_RastaMouse) excellent *'Automated Red Team Infrastructure Deployment with Terraform'* blog posts series:
- [Part 1](https://rastamouse.me/2017/08/automated-red-team-infrastructure-deployment-with-terraform---part-1/)
- [Part 2](https://rastamouse.me/2017/09/automated-red-team-infrastructure-deployment-with-terraform---part-2/)

And [@bluscreenofjeff's](https://twitter.com/bluscreenofjeff) amazing [Red Team Infrastructure Wiki](https://github.com/bluscreenofjeff/Red-Team-Infrastructure-Wiki)

Both of these resources were referenced heavily while building this.

# Setup

**Red Baron only supports Terraform version 0.10.0 or newer and will only work on Linux x64 systems.** 

```
#~ git clone https://github.com/Coalfire-Research/Red-Baron && cd Red-Baron
#~ export AWS_ACCESS_KEY_ID="accesskey"
#~ export AWS_SECRET_ACCESS_KEY="secretkey"
#~ export AWS_DEFAULT_REGION="us-east-1"
#~ export LINODE_API_KEY="apikey"
#~ export DIGITALOCEAN_TOKEN="token"
#~ export GODADDY_API_KEY="gdkey"
#~ export GODADDY_API_SECRET="gdsecret"
#~ export ARM_SUBSCRIPTION_ID="azure_subscription_id"
#~ export ARM_CLIENT_ID="azure_app_id"
#~ export ARM_CLIENT_SECRET="azure_app_password"
#~ export ARM_TENANT_ID="azure_tenant_id"

# copy an infrastructure configuration file from the examples folder to the root directory and modify it to your needs
#~ cp examples/complete_c2.tf .

#~ terraform init
#~ terraform plan
#~ terraform apply
```
## Google Cloud Compute
Google Cloud Compute requires creating a project under the Google Cloud console. 
- [Create a project](https://cloud.google.com/dataproc/docs/guides/setup-project), generate a service key, and download the json file to the google_keys dir. 
- Modify the variable.tf and main.tf files to reference your service account key json file and your project-id. 
- Set up firewall rules in the Google Cloud Console: Settings -> VPC network -> Firewall rules. Create a new rule:

```
network=default, priority=1, direction=ingress, action on match=allow, ip-range=0.0.0.0/24, protocols:ports=tcp:22,tcp:80,tcp:443
```

# Tool & Module Documentation

For detailed documentation on the tool and each module please see Red Baron's [wiki](https://github.com/coalfire/pentest-red-baron/wiki).

Most of the documentation assumes you are familiar with [Terraform](https://www.terraform.io/) itself, [Terraform's](https://www.terraform.io/) documentation can be found [here](https://www.terraform.io/docs/index.html).

# Known Bugs/Limitations

- SSH keys are deleted only when you explicitly run ```terraform destroy``` (https://github.com/hashicorp/terraform/issues/13549)

- Variables in provider fields are not supported which removes the ability to spin up AWS instances in different regions (https://github.com/hashicorp/terraform/issues/11578)

- A resources ```count``` parameter cannot be a dynamic value which means we must pass it as a module variable instead of inferring it from the length of the list we give it as a argument (https://github.com/hashicorp/terraform/issues/14677)

- LetsEncrypt cert creation using the TLS challenge currently doesn't work due to the third-party terraform ACME plugin implementation (https://github.com/paybyphone/terraform-provider-acme#using-http-and-tls-challenges). (I probably could get it to work with some extra tinkering)

- The GoDaddy modules replace **all** of the DNS entries instead of adding the specified record to the existing zone file due to the implementation of the third-party provider (https://github.com/n3integration/terraform-godaddy). (Not ideal and definitely need to work on this, but it will due for now)

# License

This project is released as 100% open-source to help the security community. 
Feel free to take the code, use it how you wish, just keep in mind that if it's my code, 
attribute me BUT MORE IMPORTANTLY if I used someone else's code or ideas, 
make sure to credit them and respect their licenses. 

Our goal for this code is to help the security community and vulnerability research in general, 
so don't use it commercially. Let information be free!
