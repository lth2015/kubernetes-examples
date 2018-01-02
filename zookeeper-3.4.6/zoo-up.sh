#!/bin/bash

kubectl create -f zookeeper-1-rc.json --validate=false
kubectl create -f zookeeper-1-svc.json

kubectl create -f zookeeper-2-rc.json --validate=false
kubectl create -f zookeeper-2-svc.json

kubectl create -f zookeeper-3-rc.json --validate=false
kubectl create -f zookeeper-3-svc.json

kubectl create -f zookeeper-4-rc.json --validate=false
kubectl create -f zookeeper-4-svc.json

kubectl create -f zookeeper-5-rc.json --validate=false
kubectl create -f zookeeper-5-svc.json
