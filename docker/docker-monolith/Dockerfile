FROM ubuntu:16.04

ENV APP_HOME /reddit
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update && \
apt-get install -y mongodb-server ruby-full ruby-dev build-essential && \
gem install bundler

COPY . $APP_HOME

RUN cd /reddit && \
bundle install && \
mv mongod.conf /etc/mongod.conf && \
mv start.sh /start.sh && \
chmod 0777 /start.sh

CMD ["/start.sh"]
