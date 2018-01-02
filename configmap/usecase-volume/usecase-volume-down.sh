#!/bin/bash
kubectl delete -f configmap.yaml
kubectl delete -f busybox-pod-how.yaml
kubectl delete -f busybox-pod-type.yaml
