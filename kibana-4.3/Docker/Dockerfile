FROM ubuntu:14.04

MAINTAINER dawei.li@company.com

RUN mkdir /opt/kibana

ADD kibana-4.3.1-linux-x64/ /opt/kibana/

EXPOSE 5601

CMD ["/opt/kibana/bin/kibana"]
