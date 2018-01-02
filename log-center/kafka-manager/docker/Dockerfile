################################################################
# Image: img.reg.3g:15000/kafka-manager:1.2.0
# kafka-manager: 1.2.0
# KafkaOffsetMonitor: KafkaOffsetMonitor-assembly-0.2.0.jar
#################################################################

FROM img.reg.3g:15000/jdk:1.7.0_67

RUN mkdir -p /usr/local/KafkaOffsetMonitor/log/

ADD kafka-manager-1.2.0/ /usr/local/kafka-manager

ADD KafkaOffsetMonitor-assembly-0.2.0.jar /usr/local/KafkaOffsetMonitor

ADD run.sh /run.sh

EXPOSE 8086

EXPOSE 9001

ENTRYPOINT ["/run.sh"]
