#! /bin/bash
java -cp /opt/KafkaOffsetMonitor-assembly-0.2.1.jar com.quantifind.kafka.offsetapp.OffsetGetterWeb --zk ${ZK_SERVER_LIST} --port 8086 --refresh 10.seconds --retain 2.days &
/opt/kafka-manager-1.2.0/bin/kafka-manager -Dconfig.file=/opt/kafka-manager-1.2.0/conf/application.conf -Dhttp.port=9001 
