#!/bin/bash

kubectl delete -f zookeeper-1-rc.json
kubectl delete -f zookeeper-1-svc.json

kubectl delete -f zookeeper-2-rc.json
kubectl delete -f zookeeper-2-svc.json

kubectl delete -f zookeeper-3-rc.json
kubectl delete -f zookeeper-3-svc.json

kubectl delete -f zookeeper-4-rc.json
kubectl delete -f zookeeper-4-svc.json

kubectl delete -f zookeeper-5-rc.json
kubectl delete -f zookeeper-5-svc.json
