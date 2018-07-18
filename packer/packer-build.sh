#!/bin/bash
# packer-build.sh

echo "./packer-build.sh build app.json for build"
echo "./packer-build.sh validate app.json for validate"

/opt/devops/packer $1 -var-file=variables.json $2

# packer $1 \
#   -var-file=variables.json \
#   ubuntu16.json

