#!/bin/bash
docker run -d --restart=always --name company-img-server  -v /mnt/company/company-img/public/:/tmp --privileged=true company/docker-nfs-server /tmp
