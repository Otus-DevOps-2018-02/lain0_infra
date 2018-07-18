#!/bin/bash -e
# install_ruby.sh

# install ruby
apt update && sudo apt upgrade -y
apt install -y ruby-full ruby-bundler build-essential
# ruby -v
