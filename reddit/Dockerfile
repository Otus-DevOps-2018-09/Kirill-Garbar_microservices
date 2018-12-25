FROM ubuntu:16.04

RUN apt-get update && \
apt-get install -y mongodb-server ruby-full ruby-dev build-essential && \
gem install bundler


COPY mongod.conf /etc/mongod.conf
COPY start.sh /start.sh

RUN cd /reddit && bundle install
RUN chmod 0777 /start.sh

CMD ["/start.sh"]
