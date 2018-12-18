#!/usr/bin/env bash
# install mongodb at ubuntu 16.04

set -e

# install
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
apt-get update
apt-get install -y mongodb-org

# change config
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

# start
systemctl start mongod
systemctl enable mongod
