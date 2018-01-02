#!/bin/bash

kubectl delete rc log-es-client
kubectl delete rc log-es-master
kubectl delete rc log-es-data-1
kubectl delete rc log-es-data-2

kubectl delete -f service-account.json

kubectl delete -f es-discovery-svc.json
kubectl delete -f es-svc.json
kubectl delete -f es-master-svc.json
