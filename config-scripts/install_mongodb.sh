#!/usr/bin/env bash
# install mongodb at ubuntu 16.04

set -e

# install
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
apt update
apt install -y mongodb-org

# start
systemctl start mongod
systemctl enable mongod
