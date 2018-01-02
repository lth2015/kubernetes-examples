#!/bin/bash
kubectl create -f android-rc-1.yaml --validate=false
kubectl create -f android-rc-2.yaml --validate=false
