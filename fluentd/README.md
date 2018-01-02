Use Fluentd in Kubernetes Cluster
====================================================================

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
  type elasticsearch
  logstash_format true
  #host "#{ENV['ES_PORT_9200_TCP_ADDR']}" # dynamically configured to use Docker's link feature
  host "elasticsearch"
  port 9200
  flush_interval 5s
</match>
```

##### Build the Fluentd Image
```bash
docker build -t company/fluentd
```

### Use Fluentd in Kubernetes Cluster
##### Edit the fluentd-controller.yaml
```bash
apiVersion: v1
kind: ReplicationController
metadata:
  name: fluentd
  labels:
    name: fluentd
spec:
  replicas: 10
  selector:
    name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      containers:
      - name: fluentd
        image: registry.docker.company.com:5000/company/fluentd
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
kubectl create -f fluentd-contorller.yaml
```


### It's Ok ~~~~~~~~~~~~~
