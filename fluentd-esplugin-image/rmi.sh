#!/bin/bash

# kubectl delete rc push-android


for i in {2..8}
do 
    echo "172.21.1.2$i ---------------------------> node$i"
    # ssh root@node$i "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
    # ssh root@node$i "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
    # ssh root@node$i "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' >> /etc/apt/sources.list"
    ssh root@node$i "docker rmi -f registry.docker:5000/tdagent:1.15"
done
