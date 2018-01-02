Use Fluentd-Collector in Kubernetes Cluster
====================================================================

### Fluentd-Collector used to collector docker logs and send them to kafka cluster

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

##### Edit fluent.conf: fluentd collect the docker logs and send them to elasticsearch cluster
```bash
cat fluentd.conf
<source>
  type tail
  read_from_head true
  path /var/lib/docker/containers/*/*-json.log
  pos_file /var/log/fluentd-docker.pos
  time_format %Y-%m-%dT%H:%M:%S
  tag docker.*
  format json
</source>

# Using filter to add container IDs to each event
<filter docker.var.lib.docker.containers.*.*.log>
  type record_transformer
  <record>
    container_id ${tag_parts[5]}
  </record>
</filter>

<match docker.var.lib.docker.containers.*.*.log>
  type   kafka
  host   kafka
  port   9092
  partition 0
  default_topic k8s.kafka.fluentd
  output_data_type json
  required_acks 1
</match>
```

##### Build the Fluentd Image
```bash
docker build -t company/fluentd-collector
```

### Use Fluentd in Kubernetes Cluster
##### Edit the fluentd-collector-controller.yaml
```bash
apiVersion: v1
kind: ReplicationController
metadata:
  name: fluentd-collector
  labels:
    name: fluentd-collector
spec:
  replicas: 1
  selector:
    name: fluentd-collector
  template:
    metadata:
      labels:
        name: fluentd-collector
    spec:
      containers:
      - name: fluentd-collector
        image: registry.docker.company.com:5000/company/fluentd-collector
        volumeMounts:
        - name: docker
          mountPath: "/var/lib/docker/containers"
      volumes:
        - name: docker
          hostPath: 
            path: "/var/lib/docker/containers"
```

##### Create fluentd-controller
```bash
kubectl create -f fluentd-collector-contorller.yaml
```


### It's Ok ~~~~~~~~~~~~~
