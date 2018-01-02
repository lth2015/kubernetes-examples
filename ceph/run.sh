#!/bin/bash
docker run -d --net=host -v /var/lib/ceph:/var/lib/ceph -v /etc/ceph:/etc/ceph -e MON_IP=172.21.1.11 -e CEPH_NETWORK=172.21.1.0/24 ceph/demo
