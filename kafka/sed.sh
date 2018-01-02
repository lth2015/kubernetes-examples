#!/bin/bash
sed -i 's/broker.id=0/broker.id='$BROKERID'/g' /home/kafka/kafka/config/server.properties
#/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties 
