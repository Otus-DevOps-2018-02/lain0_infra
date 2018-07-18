#!/bin/bash -x
# gcloud_init.sh

# set project_id
gcloud config set project infra-198609

# create new gcloud instance
gcloud compute instances create reddit-app-startup-script \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=gcloud_startup-script.sh

# open firewall tcp:9292 port for non-standart puma server
gcloud compute firewall-rules create puma-server \
  --action allow \
  --direction ingress \
  --rules tcp:9292 \
  --source-ranges 0.0.0.0/0 \
  --priority 1000 \
  --target-tags puma-server
