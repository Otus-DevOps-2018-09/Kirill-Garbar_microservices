FROM python:3.6.0-alpine

ENV APP_HOME /reddit/app/post-py
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

RUN apk --no-cache add --virtual build-tools gcc musl-dev \
&& pip install -r ${APP_HOME}/requirements.txt \
&& apk del build-tools

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
