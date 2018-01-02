YeepaySite Boss Server Dockerized and Clusted example
================

### Yeepay Boss Server Docker file
----
##### Dockerfile
```dockerfile
#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/company-boss
RUN mkdir /usr/local/company-boss/output
ADD company-boss /usr/local/company-boss

EXPOSE 8080
ENTRYPOINT ["/usr/bin/node", "/usr/local/company-boss/company-boss.js"]
```

##### Build the docker images
```bash
docker build -t company/company-boss:latest .
```

##### Install a volume by NFS which contain company's images 
```bash
docker run -d --restart=always --name company-boss-server  -v /mnt/nfs/company-boss/logs:/tmp --privileged=true company/docker-nfs-server /tmp
```
[Download]("nfs-company-boss.bash")

##### Get the ip address of the docker container
```bash
docker inspect company-boss-server | grep IPAddress
"IPAddress": "172.17.0.20"
```
##### Test the NFS server
```bash
showmount -e 172.17.0.20
Export list for 172.17.0.1:
/tmp *
```

##### Test nfs mount
```bash 
mkdir /nfs
mount -t nfs 172.17.0.20:/tmp /nfs
umount /nfs
rm -fr /nfs
```

Use Yeepay Boss Server in K8s Cluster
-------------------------

### Deploy Yeepay Boss Server

##### Edit company-boss-server-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: company-boss
  labels:
    name: company-boss
spec:
  replicas: 2
  selector:
    name: company-boss
  template:
    metadata:
      labels:
        name: company-boss
    spec:
      containers:
      - name: company-boss
        image: registry.docker.company.com:5000/company/company-boss:v1.0.0
        ports:
        - containerPort: 8080
```
[Download]("company-boss-server-controller.yaml")

#####  Create company-boss-server-controller.yaml
```bash
kubectl create -f company-boss-server-controller.yaml

kubectl get rc,pods
CONTROLLER   CONTAINER(S)   IMAGE(S)            SELECTOR          REPLICAS
company-boss   master         company/company-boss  name=company-boss  2

NAME               READY     STATUS    RESTARTS   AGE
company-boss-7yhr7   1/1       Running   1          1h
company-boss-8k8vf   1/1       Running   1          1h
```

##### Edit the company-boss-server-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: company-boss
  labels:
    name: company-boss
spec:
  ports:
    # the port that this service should serve on
  - port: 8080
    targetPort: 8080
    protocol: TCP
    nodePort: 32766
  type: "NodePort"
  selector:
    name: company-boss
```
[Download]("company-boss-server-service.yaml")

##### Create the company-boss-server-service
```bash
kubectl create -f company-boss-server-service.yaml

NAME         LABELS                                    SELECTOR          IP(S)           PORT(S)
company-boss  name=company-boss                          name=company-boss  192.168.3.108   8080/TCP
```

##### Test the company-boss-server-service
```bash
curl 192.168.3.108:8080
Empty reply from server
```

### Yeah!~~~~~
