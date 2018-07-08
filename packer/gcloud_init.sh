#!/bin/bash -x
# gcloud_init.sh

# set project_id
gcloud config set project infra-198609


# open firewall tcp:9292 port for non-standart puma server
gcloud compute firewall-rules create puma-server \
  --action allow \
  --direction ingress \
  --rules tcp:9292 \
  --source-ranges 0.0.0.0/0 \
  --priority 1000 \
  --target-tags puma-server
