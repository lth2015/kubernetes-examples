#!/bin/bash
docker run -d --restart=always --name nfs-mongo-master -v /mnt/nfs/mongo-master:/tmp --privileged=true company/docker-nfs-server /tmp
docker run -d --restart=always --name nfs-mongo-slave1 -v /mnt/nfs/mongo-slave1:/tmp --privileged=true company/docker-nfs-server /tmp
docker run -d --restart=always --name nfs-mongo-slave2 -v /mnt/nfs/mongo-slave2:/tmp --privileged=true company/docker-nfs-server /tmp
