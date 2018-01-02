#!/bin/bash

kubectl delete rc es-client1 
kubectl delete rc es-client2 
kubectl delete rc es-client3 
kubectl delete rc es-data    
kubectl delete rc es-data1   
kubectl delete rc es-data2   
kubectl delete rc es-data3   
kubectl delete rc es-data4   
kubectl delete rc es-master1 
kubectl delete rc es-master2 
kubectl delete rc es-master3 


kubectl delete -f service-account.json

kubectl delete -f es-discovery-svc.json
kubectl delete -f es-svc.json
