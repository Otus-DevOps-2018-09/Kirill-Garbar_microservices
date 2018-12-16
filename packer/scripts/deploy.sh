#!/usr/bin/env bash
# deploy application

set -e

git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
