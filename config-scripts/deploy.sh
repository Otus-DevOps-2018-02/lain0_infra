#!/bin/bash
# deploy.sh

# git clone app
cd /home/appuser/
git clone -b monolith https://github.com/express42/reddit.git

cd reddit && bundle install

#start puma as deamon
puma -d

