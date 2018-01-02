#!/bin/bash

# kafka-mananger
/usr/local/kafka-manager/bin/kafka-manager  -Dconfig.file=/usr/local/kafka-manager/conf/application.conf -Dhttp.port=9001 & 

# KafkaOffsetMonitor
java -cp /usr/local/KafkaOffsetMonitor/KafkaOffsetMonitor-assembly-0.2.0.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
          --zk zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181,zookeeper-4:2181,zookeeper-5:2181 \
	       --port 8086 \
	            --refresh 10.seconds \
		         --retain 2.days 1>/usr/local/KafkaOffsetMonitor/log/stdout.log 2>/usr/local/KafkaOffsetMonitor/log/stderr.log 
