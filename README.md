# Red Baron

- Linode Provider: https://github.com/LinodeContent/terraform-provider-linode
- GoDaddy Provider: https://github.com/n3integration/terraform-godaddy

# Setup

```
#~ export AWS_ACCESS_KEY_ID="anaccesskey"
#~ export AWS_SECRET_ACCESS_KEY="asecretkey"
#~ export AWS_DEFAULT_REGION="us-east-1"
#~ export LINODE_API_KEY="apikey"
#~ export GODADDY_API_KEY="gdkey"
#~ export GODADDY_API_SECRET="gdsecret"
#~ terraform init
#~ terraform plan
#~ terraform apply
```

# Known Bugs/Limitations

- SSH keys are deleted only when you explicitly run ```terraform destroy``` (https://github.com/hashicorp/terraform/issues/13549)

- Variables in provider fields are not supported which removes the ability to spin up AWS instances in different regions (https://github.com/hashicorp/terraform/issues/11578)

- A resources ```count``` parameter cannot be a dynamic value which means we must pass it as a module variable instead of inferring it from the length of the list we give it as a argument (https://github.com/hashicorp/terraform/issues/14677)

- LetsEncrypt cert creation using the TLS challenge doesn't work due to the third-party terraform ACME plugin implementation (https://github.com/paybyphone/terraform-provider-acme#using-http-and-tls-challenges)