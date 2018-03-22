#!/bin/bash +x
# gcloud_startup-script.sh

# install ruby
sudo apt update && sudo apt upgrade
sudo apt install -y ruby-full ruby-bundler build-essential

# install mondoDB
# add gpg keys & add repo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

sudo apt update && sudo apt upgrade
sudo apt install -y mongodb-org

# start MongoDB:
sudo systemctl start mongod

# add to autostart
sudo systemctl enable mongod

# status
# sudo systemctl status mongod

# git clone app
cd /home/appuser/
git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install

# start puma as deamon
puma -d

# know puma's port
# ps aux | grep puma
