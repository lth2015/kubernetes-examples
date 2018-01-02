#!/bin/bash -

# export JAVA_HOME=/opt/jdk1.7.0_79
# export PATH=$PATH:$JAVA_HOME/bin
# CLASSPATH="."
# for jarfile in `ls lib/.`; do
#     CLASSPATH="${CLASSPATH}:lib/$jarfile"
# done
# for jarfile in `ls transfer4j*.jar`; do
#     CLASSPATH="${CLASSPATH}:$jarfile"
# done
# 
# export CLASSPATH

java -Xms8g -Xmx8g -XX:+HeapDumpOnOutOfMemoryError -cp ${CLASSPATH} -Djava.awt.headless=true -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+HeapDumpOnOutOfMemoryError -XX:+DisableExplicitGC -Dfile.encoding=UTF-8 -Djna.nosys=true -Denv=test -DfailedBufferFile=/var/log/transfer4j/cachelog/ -Dpath.home=/usr/local/transfer4j netty.Transfer4jServer
