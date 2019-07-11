#!/bin/bash

sudo apt-get install -y libpq-dev libpcap0.8-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
git clone https://github.com/rapid7/metasploit-framework
cd metasploit-framework
rvm install ruby-`(cat .ruby-version)`
gem install bundler --no-ri --no-rdoc
bundle install
