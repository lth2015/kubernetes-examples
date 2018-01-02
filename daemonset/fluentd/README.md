Kubernetes DaemonSet Example: Fluentd
---------------------------------------

### fluentd
##### create a fluentd daemonset 
```bash
cat > fluentd.yaml
```
```yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: default
spec:
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      dnsPolicy: "ClusterFirst"
      restartPolicy: "Always"
      containers:
      - name: fluentd
        image: fluentd:v0.1.0
        imagePullPolicy: "Always"
        env:
        - name: ES_HOST
          value: http://elasticsearch
        - name: ES_PORT
          value: "9200"
        volumeMounts:
          - mountPath: /var/lib/docker/containers
            name: docker-container
      volumes:
        - hostPath:
            path: /var/lib/docker/containers
          name: docker-container
```

```bash
kubectl create -f fluentd.yaml

kubectl get ds
NAME           DESIRED   CURRENT   NODE-SELECTOR   AGE
fluentd	       4         4         <none>          2h

kubectl get nodes
NAME           STATUS    AGE
10.254.4.144   Ready     3d
10.254.5.143   Ready     3d
10.254.6.106   Ready     3d
10.254.7.106   Ready     3d

kubectl get pods 
NAME                                READY     STATUS    RESTARTS   AGE
fluentd-29xri                  1/1       Running   0          2h
fluentd-j5z1k                  1/1       Running   0          2h
fluentd-oxzki                  1/1       Running   0          2h
fluentd-rsw8f                  1/1       Running   0          2h
```
