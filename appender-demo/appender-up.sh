#!/bin/bash
kubectl create -f appender-rc.json --validate=false
kubectl create -f appender-svc.json

