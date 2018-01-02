#!/bin/bash
kubectl create configmap game-config --from-file=./
# kubectl create configmap game-config-2 --from-file=game.properties --from-file=ui.properties
