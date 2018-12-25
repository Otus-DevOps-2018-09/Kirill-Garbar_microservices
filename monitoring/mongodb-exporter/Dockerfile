FROM golang:1.11.3 as builder

ENV APPPATH $GOPATH/src/github.com/percona/mongodb_exporter
WORKDIR $APPPATH

RUN git clone "https://github.com/percona/mongodb_exporter" "$APPPATH"
RUN go get -d && GOOS=linux CGO_ENABLED=0 go build -ldflags '-extldflags "-static" -w -s' -o /mongodb_exporter

FROM alpine:latest
COPY --from=builder /mongodb_exporter /mongodb_exporter

EXPOSE 9216

ENTRYPOINT [ "/mongodb_exporter" ]
