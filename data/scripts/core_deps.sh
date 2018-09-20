#!/bin/bash

# Sometimes running apt-get install on AWS seems to produce a 503 error from the debian mirrors
# have absolutely zero clue what's going on, but just running the command again seems to fix it

sudo apt-get update
cmd="sudo apt-get install -y tmux git dirmngr debconf-utils curl wget build-essential vim gcc socat certbot mosh"
until eval $cmd
do
    sleep 10
done
