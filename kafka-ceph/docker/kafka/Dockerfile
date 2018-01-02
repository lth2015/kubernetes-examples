# Kafka:2.11_0.9.0
# company/kafka:2.11-0.9.0
FROM ubuntu:14.04
MAINTAINER dawei.li@company.com 

# Add User
RUN mkdir -p /home/kafka
# RUN adduser --disabled-password --gecos '' kafka --home /home/kafka
# RUN adduser kafka sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# RUN chown kafka.kafka /home/kafka -R
# RUN whoami
# USER kafka
# RUN whoami

WORKDIR /home/kafka

# Install Kafka
RUN sudo sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN sudo apt-get update -yqq && sudo apt-get install -y default-jre wget

ADD kafka_2.11-0.9.0.1/ /home/kafka/

## Install KafkaT
# RUN sudo apt-get install -y ruby ruby-dev build-essential
# RUN sudo gem install kafkat --source https://rubygems.org --no-ri --no-rdoc
# COPY .kafkatcfg /home/kafka/
# RUN kafkat partitions


EXPOSE 9092

#########################################################################################################################
# History                       ’-‘  ’-‘  ’-‘  ’-‘  ’-‘ ’-‘  ’-‘ 
#########################################################################################################################

# Multi-Node Broker-id
# RUN sed -i "s/broker.id=0/broker\.id=\${env:SERVER_ID}/g" /home/kafka/kafka/config/server.properties
#ENV BROKERID=1
#COPY sed.sh /home/kafka/
#ENTRYPOINT ["/home/kafka/sed.sh"]
#RUN nohup /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /tmp/kafka.log 2>&1 &
