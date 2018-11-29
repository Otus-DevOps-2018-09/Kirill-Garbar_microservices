#!/usr/bin/env bash
# install ruby at ubuntu 16.04

set -e

# install
apt-get update
apt-get install -y ruby-full ruby-bundler build-essential

# check
ruby -v
bundle -v
