########################################
# Image: transfer4j:1.0-SNAPSHOT
########################################

FROM img.reg.3g:15000/jdk:1.7.0_67

ADD transfer4j/ /usr/local/transfer4j

RUN mkdir -p /var/log/transfer4j/cachelog

ENV CLASSPATH /usr/local/transfer4j/lib:/usr/local/transfer4j/transfer4j-1.0-SNAPSHOT-lib.jar

ADD run.sh /

RUN chmod +x /run.sh

EXPOSE 24324

ENTRYPOINT ["/run.sh"]
