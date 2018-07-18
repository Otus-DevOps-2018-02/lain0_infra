#!/bin/bash
# install_mongodb.sh

# install mondoDB
# add gpg keys & add repo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

sudo apt update && sudo apt upgrade -y
sudo apt install -y mongodb-org

# start MongoDB:
sudo systemctl start mongod
# enable autostart
sudo systemctl enable mongod
# status
sudo systemctl status mongod
