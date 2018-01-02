FROM registry.docker.company.com:5000/company/fluentd-base:latest
MAINTAINER dawei.li@company.com

ADD fluent.conf /etc/fluent/
ENTRYPOINT ["/usr/local/bundle/bin/fluentd", "-c", "/etc/fluent/fluent.conf"]
