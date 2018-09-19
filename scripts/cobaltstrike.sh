#!/bin/bash

CSTRIKE_KEY='xxxx-xxxx-xxxx-xxxx'

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
echo "oracle-java8-installer shared/accepted-oracle-licence-v1-1 boolean true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

token=`curl -s https://www.cobaltstrike.com/download -d "dlkey=${CSTRIKE_KEY}" | grep 'href="/downloads/' | cut -d '/' -f3`
curl -s https://www.cobaltstrike.com/downloads/${token}/cobaltstrike-trial.tgz -o /tmp/cobaltstrike.tgz

echo ${CSTRIKE_KEY} > ~/.cobaltstrike.license
sudo cp ~/.cobaltstrike.license /root/.cobaltstrike.license

mkdir ~/cobaltstrike
tar zxf /tmp/cobaltstrike.tgz -C ~/
rm /tmp/cobaltstrike.tgz

git clone https://github.com/rsmudge/Malleable-C2-Profiles.git ~/cobaltstrike/c2-profiles
git clone https://github.com/killswitch-GUI/CobaltStrike-ToolKit ~/cobaltstrike/cs-toolkit

cd ~/cobaltstrike
./update
