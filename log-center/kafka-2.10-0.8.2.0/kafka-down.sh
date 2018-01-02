#!/bin/bash

kubectl delete -f kafka-1-pod.json 
kubectl delete -f kafka-1-svc.json

kubectl delete -f kafka-2-pod.json
kubectl delete -f kafka-2-svc.json

kubectl delete -f kafka-3-pod.json 
kubectl delete -f kafka-3-svc.json
