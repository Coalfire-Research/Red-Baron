#!/bin/bash

# For some reason it seems TF doesn't support EC keys which is a bit retarded
 
ssh-keygen -t rsa -b 4096 -f ./ssh_keys/dns_c2 -N ''
ssh-keygen -t rsa -b 4096 -f ./ssh_keys/http_c2 -N ''
ssh-keygen -t rsa -b 4096 -f ./ssh_keys/http_rdir -N ''
ssh-keygen -t rsa -b 4096 -f ./ssh_keys/dns_rdir -N ''