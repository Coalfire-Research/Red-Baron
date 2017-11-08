#!/bin/bash

# I just want to point out it took longer to get Empire to install correctly than actually coding this whole freaking thing

git clone https://github.com/EmpireProject/Empire
cd Empire/setup
sudo apt-get install -y make g++ python-dev python-m2crypto swig python-pip libxml2-dev default-jdk libffi-dev libssl1.0-dev zlib1g-dev
sudo pip install --upgrade urllib3
sudo pip install setuptools
sudo pip install pycrypto
sudo pip install iptools
sudo pip install pydispatcher
sudo pip install flask
sudo pip install macholib
sudo pip install dropbox
sudo pip install cryptography
sudo pip install pyOpenSSL
sudo pip install 'pyopenssl==17.2.0'
sudo pip install zlib_wrapper
sudo pip install netifaces
sudo pip install M2Crypto

# Install PowerShell
wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-3_amd64.deb
wget http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u6_amd64.deb
sudo dpkg -i libicu52_52.1-3_amd64.deb
sudo dpkg -i libssl1.0.0_1.0.1t-1+deb8u6_amd64.deb
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
sudo apt-get update
sudo apt-get install -y powershell
sudo rm /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY
sudo mkdir -p /usr/local/share/powershell/Modules
sudo cp -r ../lib/powershell/Invoke-Obfuscation /usr/local/share/powershell/Modules

# Install bomutils and xar
tar -xvf ../data/misc/xar-1.5.2.tar.gz
(cd xar-1.5.2 && ./configure)
(cd xar-1.5.2 && make)
(cd xar-1.5.2 && sudo make install)
git clone https://github.com/hogliux/bomutils.git
(cd bomutils && make)
(cd bomutils && sudo make install)
chmod 755 bomutils/build/bin/mkbom 
sudo cp bomutils/build/bin/mkbom /usr/local/bin/mkbom

# Setup database and cert
export STAGING_KEY="RANDOM"
./setup_database.py
./cert.sh