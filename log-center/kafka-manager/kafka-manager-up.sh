#!/bin/bash
kubectl create -f kafka-manager-rc.json --validate=false
kubectl create -f kafka-manager-svc.json

