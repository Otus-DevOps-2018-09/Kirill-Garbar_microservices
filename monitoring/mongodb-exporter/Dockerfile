FROM golang:1.11.3 as builder

ENV APPPATH $GOPATH/src/github.com/percona/mongodb_exporter
WORKDIR $APPPATH

RUN git clone "https://github.com/percona/mongodb_exporter" "$APPPATH" \
    && go get -d && go build -o /mongodb_exporter

EXPOSE 9216

ENTRYPOINT [ "/mongodb_exporter" ]
