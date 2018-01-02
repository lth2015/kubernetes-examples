Yeepay GongYi Server Dockerized and Clusted example
================

### Yeepay GongYi Server Docker file
----
##### Dockerfile
```dockerfile
FROM company/jdk1.6.0_45
MAINTAINER dawei.li@company.com 

ADD tomcat-commonweal/ /apps/tomcat-commonweal/

RUN mkdir -p /apps/log/tomcat-nohup/

WORKDIR /apps/tomcat-commonweal/bin

EXPOSE 8080

# CMD ["/apps/tomcat-commonweal/bin/startup.sh"]
# ENTRYPOINT["tail -f /apps/tomcat-commonweal/logs/"]

ENTRYPOINT ["/apps/tomcat-commonweal/bin/catalina.sh", "run"]
```

##### Build the docker images
```bash
docker build -t company/gongyi:v1.0.0
```

Use Yeepay GongYi Server in K8s Cluster
-------------------------

### Deploy Yeepay GongYi Server

##### Edit gongyi-tomcat-controller.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: gongyi
  labels:
    name: gongyi
spec:
  replicas: 2
  selector:
    name: gongyi
  template:
    metadata:
      labels:
        name: gongyi
    spec:
      containers:
      - name: gongyi
        image: registry.docker.company.com:5000/company/gongyi:v1.0.0
        ports:
        - containerPort: 8080
```
[Download]("gongyi-tomcat-controller.yaml")

#####  Create gongyi-tomcat-controller.yaml
```bash
kubectl create -f gongyi-tomcat-controller.yaml

kubectl get rc
CONTROLLER    CONTAINER(S)   IMAGE(S)                                                    SELECTOR           REPLICAS
gongyi        gongyi         registry.docker.company.com:5000/company/gongyi:v1.0.0        name=gongyi        2
```

##### Edit the gongyi-tomcat-service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: gongyi
  labels:
    name: gongyi
spec:
  ports:
    # the port that this service should serve on
  - port: 8080
    targetPort: 8080
    protocol: TCP
    nodePort: 32765
  type: "NodePort"
  selector:
    name: gongyi
```
[Download]("gongyi-tomcat-service.yaml")

##### Create the gongyi-tomcat-service
```bash
kubectl create -f gongyi-tomcat-service.yaml

kubectl get svc
NAME            LABELS                                    SELECTOR           IP(S)           PORT(S)
kubernetes      component=apiserver,provider=kubernetes   <none>             192.168.3.1     443/TCP
gongyi          name=gongyi                               name=gongyi        192.168.3.102   8080/TCP
```

##### Test the gongyi-tomcat-service
```bash
curl 192.168.3.102:8080
{
  "code" : 200,
  "data" : {
    "tagline" : "This is an API endpoint."
  }
}
```

### Yeah! It's work~~~~~
