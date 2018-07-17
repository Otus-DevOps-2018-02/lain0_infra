#!/usr/bin/env bash
# terraform_reinit.sh
set -ex

echo "output or reinit"

reinit() {
    cd ../../terraform/stage/
    /opt/devops/terraform destroy --auto-approve=true && \
    /opt/devops/terraform apply --auto-approve=true
}

output(){
    cd ../../terraform/stage/ &&
    /opt/devops/terraform output
}

$1
