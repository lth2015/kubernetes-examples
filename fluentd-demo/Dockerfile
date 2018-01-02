##############################################
# fluent-demo:latest
##############################################
FROM golang:latest

MAINTAINER dawei.li@company.com 

RUN mkdir /root/src

WORKDIR /root/src

ADD src /root/src

ENV GOPATH=/root/

RUN go build main.go

ENTRYPOINT ["/root/src/main"]
