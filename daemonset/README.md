Kubernetes DaemonSet Example
---------------------------------------

### Mirco-Example
##### create a daemonset demo
```bash
cat > serve_hostname-ds.yaml
```
```yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  namespace: default
  name: daemons-demo
spec:
  template:
    metadata:
      labels:
        demo: daemons
    spec:
      containers:
      - name: hostname
        image: gcr.io/google_containers/serve_hostname:1.1
```

```bash
kubectl create -f serve_hostname-ds.yaml

kubectl get ds
NAME           DESIRED   CURRENT   NODE-SELECTOR   AGE
daemons-demo   4         4         <none>          2h

kubectl get nodes
NAME           STATUS    AGE
10.254.4.144   Ready     3d
10.254.5.143   Ready     3d
10.254.6.106   Ready     3d
10.254.7.106   Ready     3d

kubectl get pods 
NAME                                READY     STATUS    RESTARTS   AGE
daemons-demo-29xri                  1/1       Running   0          2h
daemons-demo-j5z1k                  1/1       Running   0          2h
daemons-demo-oxzki                  1/1       Running   0          2h
daemons-demo-rsw8f                  1/1       Running   0          2h
```

##### create service for this daemonset
```bash
cat > serve_hostname-svc.yaml
```
```yaml
apiVersion: v1
kind: Service
metadata:
  namespace: default
  name: daemon-demo
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 9376
  selector:
    demo: daemons
```

```bash
kubectl create -f serve_hostname-svc.yaml

kubectl get svc
NAME          CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
daemon-demo   192.168.3.199   <none>        80/TCP    2h

for ((1)) do; curl httpp://192.168.3.199/; sleep 1; done;
```

### Nginx DaemonSet example

##### kubernetes ingress use nginx daemonset as ingress controller
```yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: nginx-ingress-lb
spec:
  template:
    metadata:
      labels:
        name: nginx-ingress-lb
    spec:
      containers:
      - image: gcr.io/google_containers/nginx-ingress-controller:0.4
        name: nginx-ingress-lb
        imagePullPolicy: Always
        livenessProbe:
          httpGet:
            path: /healthz
            port: 10249
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
        # use downward API
        env:
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
        ports:
        - containerPort: 80
          hostPort: 80
        - containerPort: 443
          hostPort: 4444
        args:
        - /nginx-ingress-controller
        - --default-backend-service=default/default-http-backend
```
