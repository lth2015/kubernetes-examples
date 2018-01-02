Use MongoDB Master-Slave in Kubernetes Cluster
================

###Deploy Mongodb master
----
##### Edit mongodb-master-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mongo-master
  labels:
    name: mongo-master
spec:
  replicas: 1
  selector:
    name: mongo-master
  template:
    metadata:
      labels:
        name: mongo-master
    spec:
      containers:
      - name: master
        image: mongo
        command:
          - mongod
          - "--master"
        ports:
        - containerPort: 27017
        volumeMounts:
        - name: mongo-master
          mountPath: "/data/db"
      volumes:
        - name: mongo-master
          emptyDir: {}
```
[Download]("mongodb-master-controller.yaml")

##### Create mongodb-master-controller 
```bash 
kubectl create -f mongodb-master-controller.yaml

kubectl get rc,pods
CONTROLLER     CONTAINER(S)   IMAGE(S)   SELECTOR            REPLICAS
mongo-master   master         mongo      name=mongo-master   1

NAME                 READY     STATUS    RESTARTS   AGE
mongo-master-6po4t   1/1       Running   0          1h
```
---------------------------------------
### Deploy MongoDB Master Service
##### Edit mongodb-master-service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mongo-master
  labels:
    name: mongo-master
spec:
  ports:
    # the port that this service should serve on
  - port: 27017
    targetPort: 27017
  selector:
    name: mongo-master
```
[Download file]("mongodb-master-service.yaml")

##### Create mongodb-master-service
```bash
kubectl create -f mongodb-master-service.yaml

kubectl get svc
NAME           LABELS                                    SELECTOR            IP(S)           PORT(S)
mongo-master   name=mongo-master                         name=mongo-master   192.168.3.152   27017/TCP
```

### Deploy Mongo Slaves
-----
##### Edit mongodb-slave-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mongo-slave
  labels:
    name: mongo-slave
spec:
  replicas: 2
  selector:
    name: mongo-slave
  template:
    metadata:
      labels:
        name: mongo-slave
    spec:
      containers:
      - name: slave
        image: mongo
        command:
          - mongod
          - "--slave"
          - "--source"
          - mongo-master 
        ports:
        - containerPort: 27017
        volumeMounts:
        - name: mongo-slave
          mountPath: "/data/db"
      volumes:
        - name: mongo-slave
          emptyDir: {}
```
[Download]("mongodb-slave-controller.yaml")

##### Create mongodb-slave-controller 
```bash
CONTROLLER     CONTAINER(S)   IMAGE(S)   SELECTOR            REPLICAS
mongo-slave    slave          mongo      name=mongo-slave    2

NAME                 READY     STATUS    RESTARTS   AGE
mongo-slave-qen7k    1/1       Running   0          51m
mongo-slave-vfazx    1/1       Running   0          51m
```

##### Create mongodb-slave-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mongo-slave
  labels:
    name: mongo-slave
spec:
  ports:
    # the port that this service should serve on
  - port: 27017
    targetPort: 27017
  selector:
    name: mongo-slave
```
[Download]("mongodb-slave-service.yaml")

##### Create mongodb-slave-service
```bash
kubectl create -f mongodb-slave-service.yaml

kubectl get svc
NAME           LABELS                                    SELECTOR            IP(S)           PORT(S)
mongo-slave    name=mongo-slave                          name=mongo-slave    192.168.3.242   27017/TCP
```

Test MongoDB Master-Slaves
-------------------------
##### Write data to master via mongo-master service
```bash
mongo 192.168.3.152
>use test
>a={"name":"litanhua"}
>b={"name":"zhangjingru"}
>db.data.save(a)
>db.data.save(b)
>db.data.find()
{ "_id" : ObjectId("5628a69981b0b68ab81adf93"), "name" : "litanhua" }
{ "_id" : ObjectId("5628b519ff4a756747ef3d0b"), "name" : "zhangjingru" }
>quit()
```

##### Read data from slave via mongo-slave service
```bash
mongo 192.168.3.242
>use test
>db.data.find()
{ "_id" : ObjectId("5628a69981b0b68ab81adf93"), "name" : "litanhua" }
{ "_id" : ObjectId("5628b519ff4a756747ef3d0b"), "name" : "zhangjingru" }
>quit()
```

Yeah! It's Ok~~~~~~~
-------------------------------------
