#######################################################
# Image: img.reg.3g:15000/zookeeper:3.4.6
#######################################################

FROM img.reg.3g:15000/jdk:1.7.0_67 

MAINTAINER dawei.li@company.com

ENV ZOOKEEPER_VERSION 3.4.6

ADD Dockerfile /

ADD zookeeper/ /opt/zookeeper

WORKDIR /opt/zookeeper

COPY config-and-run.sh /opt/zookeeper/bin/

COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

EXPOSE 2181 2888 3888

VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data", "/opt/zookeeper/log"]

CMD ["/opt/zookeeper/bin/config-and-run.sh"]
