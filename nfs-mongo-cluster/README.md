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
        - name: nfs-mongo-master
          mountPath: "/data/db"
      volumes:
        - name: nfs-mongo-master
          server: 172.17.0.3
          path: "/tmp"
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
  name: mongo-slave1
  labels:
    name: mongo-slave
spec:
  replicas: 1
  selector:
    name: mongo-slave1
  template:
    metadata:
      labels:
        name: mongo-slave1
    spec:
      containers:
      - name: slave1
        image: mongo
        command:
          - mongod
          - "--slave"
          - "--source"
          - mongo-master 
          - "--smallfiles"
        ports:
        - containerPort: 27017
        volumeMounts:
        - name: nfs-mongo-slave1
          mountPath: "/data/db"
      volumes:
      - name: nfs-mongo-slave1
        server: 172.17.0.2
        path: "/tmp"
```
[Download]("mongodb-slave1-controller.yaml")

##### Create mongodb-slave-controller 
```bash
CONTROLLER     CONTAINER(S)   IMAGE(S)   SELECTOR            REPLICAS
mongo-slave1    slave1          mongo      name=mongo-slave    1

NAME                 READY     STATUS    RESTARTS   AGE
mongo-slave1-qen7k    1/1       Running   0          51m
```

##### Create mongodb-slave1-service.yaml
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
    name: mongo-slave1
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


ToDo
==========
User mongodb-slave1-controller and mongodb-slave2-controller as the mongodb-slave service

In this case, I can't use the slave1 and slave2 as in service, who can help me?

