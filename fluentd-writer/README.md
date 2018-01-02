Use Fluentd-Writer in Kubernetes Cluster
====================================================================

### Fluentd-Writer collect logs from kafka cluster and send them to elasticsearch cluster

### Dockerfile
##### Edit the Fluentd-Base Dockerfile
```bash
cat Dockfile
FROM ruby:2.2.0
MAINTAINER dawei.li@company.com 
RUN apt-get update
RUN gem install fluentd -v "~>0.12.3"
RUN mkdir /etc/fluent
RUN apt-get install -y libcurl4-gnutls-dev make
RUN /usr/local/bin/gem install fluent-plugin-elasticsearch
RUN /usr/local/bin/gem install fluent-plugin-kafka
RUN /usr/local/bin/gem install fluent-plugin-tail-multiline
RUN /usr/local/bin/gem install fluent-plugin-forest
RUN /usr/local/bin/gem install fluent-plugin-record-modifier
```

##### Build the Fluentd-Base Image
```bash
docker build -t company/fluentd-base .
```

##### Edit the Fluentd Dockerfile
```bash
FROM registry.docker.company.com:5000/company/fluentd-base:latest
MAINTAINER dawei.li@company.com

ADD fluent.conf /etc/fluent/
ENTRYPOINT ["/usr/local/bundle/bin/fluentd", "-c", "/etc/fluent/fluent.conf"]
```

##### Edit fluent.conf
```bash
<source>
  type kafka
  host kafka
  port 9092
  partition 0
  topics k8s.kafka.fluentd
  format json
</source>

<match k8s.kafka.fluentd>
  type elasticsearch
  type_name monitor
  logstash_format true
  host "elasticsearch"
  port 9200
  format json
  flush_interval 5s
</match>
```

##### Build the Fluentd Image
```bash
docker build -t company/fluentd-writer
```

### Use Fluentd in Kubernetes Cluster
##### Edit the fluentd-writer-controller.yaml
```bash
apiVersion: v1
kind: ReplicationController
metadata:
  name: fluentd-writer
  labels:
    name: fluentd-writer
spec:
  replicas: 1
  selector:
    name: fluentd-writer
  template:
    metadata:
      labels:
        name: fluentd-writer
    spec:
      containers:
      - name: fluentd-writer
        image: registry.docker.company.com:5000/company/fluentd-writer
        volumeMounts:
        - name: docker
          mountPath: "/var/lib/docker/containers"
      volumes:
        - name: docker
          hostPath: 
            path: "/var/lib/docker/containers"
```

##### Create fluentd-writer-controller
```bash
kubectl create -f fluentd-writer-contorller.yaml
```


### It's Ok ~~~~~~~~~~~~~
