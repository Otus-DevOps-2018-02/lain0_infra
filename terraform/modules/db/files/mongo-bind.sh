#!/bin/bash
# mondo-bind.sh
# bind mongo to 0.0.0.0


# mongod.conf vs bindIp: 0.0.0.0
sudo cp /tmp/mongod.conf /etc/mongod.conf && sudo systemctl restart mongod
