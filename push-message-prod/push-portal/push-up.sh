#!/bin/bash
kubectl create -f push-rc-1.yaml --validate=false
kubectl create -f push-rc-2.yaml --validate=false
