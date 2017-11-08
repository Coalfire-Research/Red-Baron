#!/bin/bash

sudo apt-get install -y libpq-dev libpcap0.8-dev
gpg --keyserver hkp://keys.gnupg.net:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ruby-2.4.2
git clone https://github.com/rapid7/metasploit-framework
cd metasploit-framework
gem install bundler
bundle install