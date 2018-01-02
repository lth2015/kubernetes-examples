YeepaySite Image Server Dockerized and Clusted example
================

### Image Server Docker file
----
##### Dockerfile
```dockerfile
#################################################### 
# For Node.js (www.company.com) 
####################################################
 
FROM company/nodejs-base
MAINTAINER lidawei dawei.li@company.com

RUN mkdir /usr/local/company-img
RUN mkdir /usr/local/company-img/output
ADD company-img /usr/local/company-img

EXPOSE 8080
ENTRYPOINT ["/usr/bin/node", "/usr/local/company-img/img-server.js"]
```

##### Build the docker images
```bash
docker build -t company/img-server:latest .
```

##### Install a volume by NFS which contain company's images 
```bash
docker run -d --restart=always --name company-img-server  -v /mnt/company/images/company-img/public/:/tmp --privileged=true company/docker-nfs-server /tmp
```
[Download]("nfs-company-image.bash")

##### Get the ip address of the docker container
```bash
docker inspect company-img-server | grep IPAddress
"IPAddress": "172.17.0.19"
```
##### Test the NFS server
```bash
showmount -e 172.17.0.19
Export list for 172.17.0.1:
/tmp *
```

##### Test nfs mount
```bash 
mkdir /nfs
mount -t nfs 172.17.0.19:/tmp /nfs
umount /nfs
rm -fr /nfs
```

Use Yeepay Image Server in K8s Cluster
-------------------------

### Deploy Yeepay Image Server

##### Edit company-image-server-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: company-img
  labels:
    name: company-img
spec:
  replicas: 2
  selector:
    name: company-img
  template:
    metadata:
      labels:
        name: company-img
    spec:
      containers:
      - name: master
        image: company/img-server
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: nfs-company-img
          mountPath: "/usr/local/company-img/public"
      volumes:
        - name: nfs-company-img
          server: 172.17.0.19
          path: "/tmp"
```
[Download]("company-img-server-controller.yaml")

#####  Create company-img-server-controller.yaml
```bash
kubectl create -f company-img-server-controller.yaml

kubectl get rc,pods
CONTROLLER   CONTAINER(S)   IMAGE(S)            SELECTOR          REPLICAS
company-img   master         company/img-server   name=company-img   2

NAME               READY     STATUS    RESTARTS   AGE
company-img-7yhr7   1/1       Running   1          1h
company-img-8k8vf   1/1       Running   1          1h
```

##### Edit the company-img-server-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: company-img
  labels:
    name: company-img
spec:
  ports:
    # the port that this service should serve on
  - port: 8080
    targetPort: 8080
  selector:
    name: company-img
```
[Download]("company-img-server-service.yaml")

##### Create the company-img-server-service
```bash
kubectl create -f company-img-server-service.yaml

NAME         LABELS                                    SELECTOR          IP(S)           PORT(S)
company-img   name=company-img                           name=company-img   192.168.3.108   8080/TCP
```

##### Test the company-img-server-service
```bash
curl 192.168.3.108:8080
Empty reply from server
```

### Yeah!~~~~~
