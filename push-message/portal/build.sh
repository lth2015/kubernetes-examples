#!/bin/bash
docker build -t push-portal:v1 .
docker tag push-portal:v1 registry.test.com:5000/push-portal:v1
docker push registry.test.com:5000/push-portal:v1
