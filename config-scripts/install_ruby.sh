#!/bin/bash
# install_ruby.sh

# install ruby
sudo apt update && sudo apt upgrade -y
sudo apt install -y ruby-full ruby-bundler build-essential
# ruby -v
