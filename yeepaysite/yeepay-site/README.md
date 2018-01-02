YeepaySite Site Server Dockerized and Clusted example
================

### Yeepay Site Server Docker file
----
##### Dockerfile
```dockerfile
#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/company-site
RUN mkdir /usr/local/company-site/output
ADD company-site /usr/local/company-site

EXPOSE 8080
ENTRYPOINT ["/usr/bin/node", "/usr/local/company-site/company-site.js"]
```

##### Build the docker images
```bash
docker build -t company/company-site:latest .
```

##### Install a volume by NFS which contain company's images 
```bash
docker run -d --restart=always --name company-site-server  -v /mnt/nfs/company-site/logs:/tmp --privileged=true company/docker-nfs-server /tmp
```
[Download]("nfs-company-site.bash")

##### Get the ip address of the docker container
```bash
docker inspect company-site-server | grep IPAddress
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

Use Yeepay Site Server in K8s Cluster
-------------------------

### Deploy Yeepay Site Server

##### Edit company-site-server-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: company-site
  labels:
    name: company-site
spec:
  replicas: 2
  selector:
    name: company-site
  template:
    metadata:
      labels:
        name: company-site
    spec:
      containers:
      - name: company-site
        image: registry.docker.company.com:5000/company/company-site:v1.0.0
        ports:
        - containerPort: 8080
```
[Download]("company-site-server-controller.yaml")

#####  Create company-site-server-controller.yaml
```bash
kubectl create -f company-site-server-controller.yaml

kubectl get rc,pods
CONTROLLER   CONTAINER(S)   IMAGE(S)            SELECTOR          REPLICAS
company-site   master         company/company-site  name=company-site  2

NAME               READY     STATUS    RESTARTS   AGE
company-site-7yhr7   1/1       Running   1          1h
company-site-8k8vf   1/1       Running   1          1h
```

##### Edit the company-site-server-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: company-site
  labels:
    name: company-site
spec:
  ports:
    # the port that this service should serve on
  - port: 8080
    targetPort: 8080
    protocol: TCP
    nodePort: 32766
  type: "NodePort"
  selector:
    name: company-site
```
[Download]("company-site-server-service.yaml")

##### Create the company-site-server-service
```bash
kubectl create -f company-site-server-service.yaml

NAME         LABELS                                    SELECTOR          IP(S)           PORT(S)
company-site  name=company-site                          name=company-site  192.168.3.108   8080/TCP
```

##### Test the company-site-server-service
```bash
curl 192.168.3.108:8080
Empty reply from server
```

### Yeah!~~~~~
