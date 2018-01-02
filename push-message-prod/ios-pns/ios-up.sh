#!/bin/bash
kubectl create -f ios-rc-1.yaml --validate=false
kubectl create -f ios-rc-2.yaml --validate=false
