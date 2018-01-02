FROM ubuntu:14.04
MAINTAINER dawei.li@company.com 

# Add User
RUN mkdir -p /home/kafka
RUN adduser --disabled-password --gecos '' kafka --home /home/kafka
RUN adduser kafka sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown kafka.kafka /home/kafka -R
RUN whoami
USER kafka
RUN whoami

WORKDIR /home/kafka

# Install Kafka
RUN sudo apt-get update -yqq && sudo apt-get install -y default-jre wget

RUN mkdir -p /home/kafka/Downloads
RUN wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/0.8.2.1/kafka_2.11-0.8.2.1.tgz" -O ~/Downloads/kafka.tgz
RUN mkdir -p /home/kafka/kafka
WORKDIR /home/kafka/kafka
RUN tar -xvzf ~/Downloads/kafka.tgz --strip 1
RUN echo "delete.topic.enable = true" >> ~/kafka/config/server.properties

## Install KafkaT
RUN sudo apt-get install -y ruby ruby-dev build-essential
RUN sudo gem install kafkat --source https://rubygems.org --no-ri --no-rdoc
COPY .kafkatcfg /home/kafka/
#RUN kafkat partitions


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
