#!/bin/bash -x
# packer-build.sh

echo "build for build or validate for validate"

./packer $1 \
  -var-file=variables.json \
  ubuntu16.json
