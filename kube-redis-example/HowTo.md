Kubernetes Official Redis Example Use EmptyDir
================
### Redis & Mongo can be used in Kubernetes Cluster as a cache resource

### EmptyDir store data in memory, it should be used in non-presistent scene

```bash
kubectl create -f redis-controller.yaml
kubectl create -f redis-master.yaml
kubectl create -f redis-proxy.yaml
```

### In this scene, scaling mongo & redis cluster is challenging job

### Message-Queue(nuts, kafuka) is a candidate

