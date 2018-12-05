FROM alpine:3.8

WORKDIR /reddit

RUN apk add git bash && mkdir app && \
echo $'cd app\n\
if [ -z "$(ls -d .git)" ]; then git init; fi;\n\
git pull https://github.com/express42/reddit.git microservices\n\
sleep 1000\n'\
> git_pull.sh
# RUN apt update && apt install -y git rsyslog && \
# git clone -b microservices https://github.com/express42/reddit.git

# ENTRYPOINT ["sh", "-c", "sleep 1000"]
CMD ["/bin/sh", "git_pull.sh"]
# CMD ["/bin/sleep", "1000"]
# ENTRYPOINT [ "sh", "-c", "echo $HOME" ]
