#!/bin/bash
kubectl create -f configmap.yaml
kubectl create -f busybox-pod-how.yaml
kubectl create -f busybox-pod-type.yaml
