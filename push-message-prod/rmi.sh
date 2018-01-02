#!/bin/bash

kubectl delete rc push-android
kubectl delete rc push-ios
kubectl delete rc push-portal


for i in {1..9}
do 
    echo "172.21.1.2$i ---------------------------> node$i"
    # ssh root@node$i "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
    # ssh root@node$i "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
    # ssh root@node$i "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' >> /etc/apt/sources.list"
    docker rmi -f registry.test.com:5000/push-android:v1
    docker rmi -f push-android:v1
    docker rmi -f registry.test.com:5000/push-ios:v1
    docker rmi -f push-ios:v1
    docker rmi -f registry.test.com:5000/push-portal:v1
    docker rmi -f push-portal:v1
    ssh root@node$i "docker rmi -f registry.test.com:5000/push-ios:v1"
    ssh root@node$i "docker rmi -f registry.test.com:5000/push-ios:v1"
    ssh root@node$i "docker rmi -f registry.test.com:5000/push-portal:v1"
done
