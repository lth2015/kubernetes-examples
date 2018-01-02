#!/bin/bash

kubectl delete -f cpzx-es-client.json
kubectl delete -f cpzx-es-master.json
kubectl delete -f cpzx-es-data-1.json
kubectl delete -f cpzx-es-data-2.json

kubectl delete -f service-account.json

kubectl delete -f es-discovery-svc.json
kubectl delete -f es-master-svc.json
kubectl delete -f es-client-svc.json
