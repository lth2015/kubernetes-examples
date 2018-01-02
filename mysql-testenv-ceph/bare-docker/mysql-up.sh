#!/bin/bash

docker run -tid --name mysql-yce --net=host -e "MYSQL_ROOT_PASSWORD=root" -p 3306:3306 -v $PWD/data:/var/lib/mysql registry.test.com:5000/mysql:latest
