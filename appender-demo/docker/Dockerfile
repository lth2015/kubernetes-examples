#######################################################
# Image: img.reg.3g:15000/appender:1.0-SNAPSHOT
#######################################################

FROM img.reg.3g:15000/jdk:1.7.0_67

RUN mkdir -p /usr/local/appender

ADD fluentd-demo-jar-with-dependencies.jar /usr/local/appender/

ADD log4j.xml /usr/local/appender/

RUN echo "*	soft	nofile	65535" >> /etc/sysctl.conf

RUN echo "*	hard	nofile	65535" >> /etc/sysctl.conf

ADD run.sh /

RUN chmod +x /run.sh

# ENTRYPOINT ["/run.sh"]
