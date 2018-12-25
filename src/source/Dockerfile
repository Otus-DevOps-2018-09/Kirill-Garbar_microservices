FROM alpine:3.8

WORKDIR /reddit

RUN apk add git bash && mkdir app && \
echo $'cd app\n\
if [ -z "$(ls -d .git)" ]; then git init; fi;\n\
git pull https://github.com/Kirill-Garbar/reddit.git microservices\n'\
> git_pull.sh

CMD ["/bin/sh", "git_pull.sh"]
