#!/bin/bash

kubectl create -f memcached-svc.yaml

kubectl create -f memcached-rc.yaml
