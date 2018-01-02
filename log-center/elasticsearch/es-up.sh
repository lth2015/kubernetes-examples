#!/bin/bash

kubectl create -f service-account.json
kubectl create -f es-discovery-svc.json
kubectl create -f es-svc.json
kubectl create -f es-master-svc.json

kubectl create -f log-es-client.json   --validate=false
kubectl create -f log-es-data-1.json     --validate=false
kubectl create -f log-es-data-2.json     --validate=false
kubectl create -f log-es-master.json   --validate=false
