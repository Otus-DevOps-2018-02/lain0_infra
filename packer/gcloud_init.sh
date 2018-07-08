#!/bin/bash -x
# gcloud_init.sh

# set project_id
gcloud config set project infra-198609

gcloud compute instances create reddit-app-packer \
  --image-family=reddit-base \
  --image-project=infra-198609 \
  --machine-type=f1-micro \
  --tags=puma-server \
  --zone=europe-west1-b \
  --restart-on-failure \
  --metadata-from-file startup-script=../config-scripts/deploy.sh

# # open firewall tcp:9292 port for non-standart puma server
# gcloud compute firewall-rules create puma-server \
#   --action allow \
#   --direction ingress \
#   --rules tcp:9292 \
#   --source-ranges 0.0.0.0/0 \
#   --priority 1000 \
#   --target-tags puma-server


# gcloud compute instances create reddit-app-packer \
#   --boot-disk-size=10GB \
#   --image-family reddit-base \
#   --image-project=infra-198609 \
#   --machine-type=g1-small \
#   --tags puma-server \
#   --zone=europe-west1-b \
#   --restart-on-failure \
#   --metadata-from-file startup-script=../config-scripts/deploy.sh
