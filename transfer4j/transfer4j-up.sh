#!/bin/bash
kubectl create -f transfer4j-rc.json --validate=false
kubectl create -f transfer4j-svc.json

