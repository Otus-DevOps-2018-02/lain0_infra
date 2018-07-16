#!/usr/bin/env bash
# terraform_reinit.sh

cd ../../terraform/stage/
/opt/devops/terraform destroy --auto-approve=true && \
/opt/devops/terraform apply --auto-approve=true
