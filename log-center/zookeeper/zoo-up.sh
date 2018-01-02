#!/bin/bash

kubectl create -f zookeeper-1-pod.json --validate=false
kubectl create -f zookeeper-1-svc.json

kubectl create -f zookeeper-2-pod.json --validate=false
kubectl create -f zookeeper-2-svc.json

kubectl create -f zookeeper-3-pod.json --validate=false
kubectl create -f zookeeper-3-svc.json

kubectl create -f zookeeper-4-pod.json --validate=false
kubectl create -f zookeeper-4-svc.json

kubectl create -f zookeeper-5-pod.json --validate=false
kubectl create -f zookeeper-5-svc.json
