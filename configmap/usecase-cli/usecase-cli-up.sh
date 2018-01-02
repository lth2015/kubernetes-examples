#!/bin/bash
kubectl create -f configmap.yaml
kubectl create -f busybox-pod.yaml
