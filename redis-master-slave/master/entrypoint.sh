#!/bin/bash

sed -i "s#\${MASTERAUTH}#${MASTERAUTH}#" /etc/redis/redis.conf

sed -i "s#\${PASSWORD}#${PASSWORD}#" /etc/redis/redis.conf

/usr/local/bin/redis-server /etc/redis/redis.conf
