#!/bin/bash
docker build -t push-android:v1 .
docker tag push-android:v1 registry.docker:5000/push-android:v1
docker push registry.docker:5000/push-android:v1