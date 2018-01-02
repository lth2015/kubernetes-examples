#!/bin/bash
docker build -t push-ios:v1 .
docker tag push-ios:v1 registry.docker:5000/push-ios:v1
docker push registry.docker:5000/push-ios:v1
