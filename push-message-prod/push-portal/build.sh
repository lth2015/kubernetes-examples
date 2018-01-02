#!/bin/bash
docker build -t push-portal:v1 .
docker tag push-portal:v1 registry.docker:5000/push-portal:v1
docker push registry.docker:5000/push-portal:v1
