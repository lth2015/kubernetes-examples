#!/bin/bash -

java -jar -Dlog4j.configuration=file:/usr/local/appender/log4j.xml /usr/local/appender/fluentd-demo-jar-with-dependencies.jar
