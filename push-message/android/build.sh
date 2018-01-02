#!/bin/bash
docker build -t push-android:v1 .
docker tag push-android:v1 registry.test.com:5000/push-android:v1
docker push registry.test.com:5000/push-android:v1
