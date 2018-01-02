#!/bin/bash

kubectl delete -f zookeeper-1-pod.json
kubectl delete -f zookeeper-1-svc.json

kubectl delete -f zookeeper-2-pod.json
kubectl delete -f zookeeper-2-svc.json

kubectl delete -f zookeeper-3-pod.json
kubectl delete -f zookeeper-3-svc.json

kubectl delete -f zookeeper-4-pod.json
kubectl delete -f zookeeper-4-svc.json

kubectl delete -f zookeeper-5-pod.json
kubectl delete -f zookeeper-5-svc.json
