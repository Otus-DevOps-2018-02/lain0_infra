#!/bin/bash
# create-reddit-vm.sh
# create instance reddit-full

# set project_id
gcloud config set project infra-198609

# create new gcloud instance

gcloud compute instances create reddit-app-packer \
  --image-family=reddit-base \
  --image-project=infra-198609 \
  --machine-type=f1-micro \
  --tags=puma-server \
  --zone=europe-west1-b \
  --restart-on-failure \
  --metadata-from-file startup-script=config-scripts/deploy.sh

# gcloud compute instances create reddit-full \
#     --image-project=infra-198609 \
#     --image-family=reddit-full \
#     --tags=puma-server \
#     --zone=europe-west1-b

# open firewall tcp:9292 port for non-standart puma server
# gcloud compute firewall-rules create puma-server \
#   --action allow \
#   --direction ingress \
#   --rules tcp:9292 \
#   --source-ranges 0.0.0.0/0 \
#   --priority 1000 \
#   --target-tags puma-server
