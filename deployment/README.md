Kubernetes Deployment Example
-----------------------------------------------------
### Related documents: http://kubernetes.io/docs/user-guide/deployments/

### Creating a Deployment
```bash
cat > nginx-deployment.yaml
```

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

##### create nginx-deployment for version:1.7.9
```bash
kubectl create -f nginx-deployment.yaml --record
```
##### view ngixn-deployment
```bash
kubectl get deployement
kubectl get rc
kubectl get pods --show-labels
NAME                                READY     STATUS              RESTARTS   AGE       LABELS
nginx-deployment-2035384211-nllka   1/1       Running             0          23m       app=nginx,pod-template-hash=2035384211
nginx-deployment-2035384211-w1jqv   1/1       Running             0          23m       app=nginx,pod-template-hash=2035384211
nginx-deployment-2035384211-x0c1a   1/1       Running             0          23m       app=nginx,pod-template-hash=2035384211

NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3         3         3            3           22m
```

### The Status of a Deployment
##### review the status of nginx-deployment
```bash
kubectl get deployment nginx-deployment -o yaml
```
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  creationTimestamp: 2016-04-12T15:52:51Z
  generation: 2
  labels:
    app: nginx
  name: nginx-deployment
  namespace: default
  resourceVersion: "539464"
  selfLink: /apis/extensions/v1beta1/namespaces/default/deployments/nginx-deployment
  uid: 9ca3c289-00c6-11e6-a09f-fa163e788d93
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:1.7.9
        imagePullPolicy: IfNotPresent
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 3
  observedGeneration: 2
  replicas: 3
  updatedReplicas: 3
```
kubectl get deployment nginx-deployment -o yaml | grep [Gg]eneration
```

### Updaing a Deployment
##### update nginx from 1.7.9 to 1.9.1
```bash
cat > nginx-deployment
```
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.9.1
        ports:
        - containerPort: 80
```
```bash
kubectl apply -f nginx-deployment.yaml 
```
##### you can edit deployment from commond line
```bash
kubectl edit deployment nginx-deployment
kubectl get deployments
```

### Mutilple Updates
##### If you update a Deployment while an existing deployment is in progress, the Deployment will create a new Replica Set as per the update and start scaling that up, and will roll the Replica Set that it was scaling up previously – it will add it to its list of old Replica Sets and will start scaling it down.
##### For example, suppose you create a Deployment to create 5 replicas of nginx:1.7.9, but then updates the Deployment to create 5 replicas of nginx:1.9.1, when only 3 replicas of nginx:1.7.9 had been created. In that case, Deployment will immediately start killing the 3 nginx:1.7.9 Pods that it had created, and will start creating nginx:1.9.1 Pods. It will not wait for 5 replicas of nginx:1.7.9 to be created before changing course.

### Rolling Back a Deployment
##### create a bad-nginx-deployment
```bash
cat > bad-nginx-deployment.yaml
```
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.91
        ports:
        - containerPort: 80
```

##### update nginx deployment
```bash
kubectl apply -f bad-nginx-deployment.yaml

kubectl get rs
NAME                          DESIRED   CURRENT   AGE
nginx-deployment-1564180365   2         2         32m
nginx-deployment-2035384211   0         0         37m
nginx-deployment-3066724191   2         2         30m

kubectl get pods 
NAME                                READY     STATUS             RESTARTS   AGE
daemons-demo-29xri                  1/1       Running            0          1h
daemons-demo-j5z1k                  1/1       Running            0          1h
daemons-demo-oxzki                  1/1       Running            0          1h
daemons-demo-rsw8f                  1/1       Running            0          1h
nginx-deployment-1564180365-klelt   1/1       Running            0          33m
nginx-deployment-1564180365-opmuu   1/1       Running            0          33m
nginx-deployment-3066724191-qmqo2   0/1       ImagePullBackOff   0          2m
nginx-deployment-3066724191-w6wd7   0/1       ImagePullBackOff   0          2m
```

##### review the history you applied in the deployment
```bash
kubectl rollout history deployment nginx-deployment
deployments "nginx-deployment":
REVISION	CHANGE-CAUSE
1		kubectl create -f nginx-deployment.yaml --record
4		kubectl apply -f bad-nginx-deployment.yaml
5		kubectl apply -f bad-nginx-deployment.yaml
```

##### you can rollout to a revision: [1 4 5]
##### rollback to a previous stable revision: eg. nginx:1.9.1
```bash
kubectl get rs
NAME                          DESIRED   CURRENT   AGE
nginx-deployment-1564180365   2         2         39m
nginx-deployment-2035384211   0         0         43m
nginx-deployment-3066724191   2         2         36m

kubectl rollout undo deployment nginx-deployment --to-revision=4
deployment "nginx-deployment" rolled back

kubectl get rs
NAME                          DESIRED   CURRENT   AGE
nginx-deployment-1564180365   3         3         39m
nginx-deployment-2035384211   0         0         44m
nginx-deployment-3066724191   0         0         37m
```

### Pausing and Resuming a Deployment

##### Note that any current state of the Deployment will continue its function, but new updates to the Deployment will not have an effect as long as the Deployment is paused.
```bash
kubectl rollout pause deployment nginx-deployment
kubectl get rs
NAME                          DESIRED   CURRENT   AGE
nginx-deployment-1564180365   3         3         45m
nginx-deployment-2035384211   0         0         50m
nginx-deployment-3066724191   0         0         42m
```

##### To resume the Deployment, simply do kubectl rollout resume
```bash
kubectl rollout resume deployment/nginx-deployment

kubectl get rs
NAME                          DESIRED   CURRENT   AGE
nginx-deployment-1564180365   3         3         46m
nginx-deployment-2035384211   0         0         51m
nginx-deployment-3066724191   0         0         44m
```

### Some commands for test deployment

##### kubectl create -f nginx-deployment.yaml --record
##### kubectl get deployments
##### kubectl get rc
##### kubectl get pods
##### kubectl get rs
##### kubectl get pods --show-labels
##### kubectl get deployment/nginx-deployment -o yaml 
##### kubectl get deployment/nginx-deployment -o yaml  | grep [Gg]eneration
##### kubectl apply -f nginx-deployment.yaml 
##### kubectl get deployments
##### kubectl edit deployment nginx-deployment
##### kubectl get deployments
##### kubectl apply -f bad-nginx-deployment.yaml 
##### kubectl get rs
##### kubectl describe deployment
##### kubectl get pods 
##### kubectl rollout history deployment/nginx-deployment --revision=2
##### kubectl rollout undo deployment/nginx-deployment
##### kubectl get deployment
##### kubectl get pods
##### kubectl get pods --show-label
##### kubectl get pods --show-labels
##### kubectl rollout undo deployment/nginx-deployment --to-revision=2
##### kubectl rollout pause deployment/nginx-deployment
##### kubectl rollout resume deployment/nginx-deployment
