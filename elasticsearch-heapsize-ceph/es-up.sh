#!/bin/bash

kubectl create -f secret/

kubectl create -f service-account.json
kubectl create -f es-discovery-svc.json
kubectl create -f es-svc.json

kubectl create -f es-client1-rc-heapsize.json   --validate=false
kubectl create -f es-client2-rc-heapsize.json   --validate=false
kubectl create -f es-client3-rc-heapsize.json   --validate=false
kubectl create -f es-data1-rc-heapsize.json     --validate=false
kubectl create -f es-data2-rc-heapsize.json     --validate=false
kubectl create -f es-data3-rc-heapsize.json     --validate=false
kubectl create -f es-data4-rc-heapsize.json     --validate=false
kubectl create -f es-master1-rc-heapsize.json   --validate=false
kubectl create -f es-master2-rc-heapsize.json   --validate=false
kubectl create -f es-master3-rc-heapsize.json   --validate=false
