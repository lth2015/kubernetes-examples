Yeepay GongYi Server Dockerized and Clusted example
================

### Yeepay GongYi Server Docker file
----
##### Dockerfile
```dockerfile
#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/donate_wap
RUN mkdir /usr/local/donate_wap/output
ADD donate_wap /usr/local/donate_wap

RUN cd /usr/local/donate_wap

WORKDIR /usr/local/donate_wap

EXPOSE 8080

ENTRYPOINT ["/usr/bin/npm", "start"]
```

##### Build the docker images
```bash
docker build -t company/donate:v1.0.0
```

Use Yeepay GongYi Server in K8s Cluster
-------------------------

### Deploy Yeepay GongYi Server

##### Edit donate-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: donate
  labels:
    name: donate
spec:
  replicas: 2
  selector:
    name: donate
  template:
    metadata:
      labels:
        name: donate
    spec:
      containers:
      - name: donate
        image: registry.docker.company.com:5000/company/donate:v1.0.0
        ports:
        - containerPort: 8080
```
[Download]("donate-controller.yaml")

#####  Create donate-controller.yaml
```bash
kubectl create -f donate-controller.yaml

kubectl get rc
CONTROLLER    CONTAINER(S)   IMAGE(S)                                                    SELECTOR           REPLICAS
donate        donate         registry.docker.company.com:5000/company/donate:v1.0.0        name=donate        2
```

##### Edit the donate-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: donate
  labels:
    name: donate
spec:
  ports:
    # the port that this service should serve on
  - port: 3000
    targetPort: 3000
    protocol: TCP
    nodePort: 32764
  type: "NodePort"
  selector:
    name: donate
```
[Download]("donate-service.yaml")

##### Create the donate-service
```bash
kubectl create -f donate-service.yaml

kubectl get svc
NAME            LABELS                                    SELECTOR           IP(S)           PORT(S)
donate          name=donate                               name=donate        192.168.3.72    3000/TCP
```

##### Test the donate-service
```bash
curl 192.168.3.72:3000
```

##### You can access the doante site by 172.21.1.11:32764/ on your browser

### Yeah! It's work~~~~~
