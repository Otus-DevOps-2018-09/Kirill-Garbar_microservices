FROM ruby:2.4.5-alpine3.8

ENV APP_HOME /reddit/app/comment
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY . $APP_HOME

RUN apk --no-cache add --virtual build-tools ruby-dev g++ make ruby-bundler \
&& apk add bash curl \
&& bundle install \
&& apk del build-tools \
&& rm -rf /usr/local/bundle/cache/* \
/root/.bundle/cache/compact_index/rubygems.org*/* \
/var/cache/apk/* \
/var/cache/misc/* \
/var/cache/* \
/tmp/* \
/var/tmp/*

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
