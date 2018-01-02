#!/bin/bash
docker run -d -p 8088:8080 -v /mnt/company/company-img/public/:/usr/local/company-img/public --name company-image company/img-server
