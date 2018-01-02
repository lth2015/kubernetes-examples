#!/bin/bash

kubectl create -f service-account.json
kubectl create -f es-discovery-svc.json
kubectl create -f es-master-svc.json
kubectl create -f es-client-svc.json

kubectl create -f cpzx-es-client.json   --validate=false
kubectl create -f cpzx-es-data-1.json     --validate=false
kubectl create -f cpzx-es-data-2.json     --validate=false
kubectl create -f cpzx-es-master.json   --validate=false
