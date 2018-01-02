#!/bin/bash

kubectl create -f kafka-1-pod.json --validate=false
kubectl create -f kafka-1-svc.json

kubectl create -f kafka-2-pod.json --validate=false
kubectl create -f kafka-2-svc.json

kubectl create -f kafka-3-pod.json --validate=false
kubectl create -f kafka-3-svc.json
