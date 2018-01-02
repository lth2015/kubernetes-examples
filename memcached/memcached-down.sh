#!/bin/bash

kubectl delete -f memcached-svc.yaml

kubectl delete -f memcached-rc.yaml
