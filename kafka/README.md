Use Zookeeper Cluster in Kubernetes Cluster
=========================

### Pull fabric8/kafka image from docker hub
##### Tag and Push fabric8/kafka to local docker registry
```bash
docker pull fabric8/kafka 
docker tag fabric8/kafka registry.docker.company.com:5000/company/kafka
docker push registry.docker.company.com:5000/company/kafka
```

### Deploy kafka cluster
#### Edit the kafka-cluster-list.yaml
```yaml
kind: "List"
apiVersion: "v1"
id: "kafka"
items: 
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "kafka-1"
      labels: 
        name: "kafka"
        server-id: "1"
    spec: 
      containers: 
        - name: "kafka"
          image: "registry.docker.company.com:5000/company/kafka"
          #env: 
          #  - name: "BROKERID"
          #    value: "1"
          ports: 
            - containerPort: 9092
          command: ['/bin/sh', '-c']
          args: ['sed -i -- ''s/broker.id=0/broker.id=1/g'' /home/kafka/kafka/config/server.properties && sed -i -- ''s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/g'' /home/kafka/kafka/config/server.properties && /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties ']
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "kafka-2"
      labels: 
        name: "kafka"
        server-id: "1"
    spec: 
      containers: 
        - name: "kafka"
          image: "registry.docker.company.com:5000/company/kafka"
          #env: 
          #  - name: "BROKERID"
          #    value: "1"
          ports: 
            - containerPort: 9092
          command: ['/bin/sh', '-c']
          args: ['sed -i -- ''s/broker.id=0/broker.id=2/g'' /home/kafka/kafka/config/server.properties && sed -i -- ''s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/g'' /home/kafka/kafka/config/server.properties && /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties ']
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "kafka-3"
      labels: 
        name: "kafka"
        server-id: "1"
    spec: 
      containers: 
        - name: "kafka"
          image: "registry.docker.company.com:5000/company/kafka"
          #env: 
          #  - name: "BROKERID"
          #    value: "1"
          ports: 
            - containerPort: 9092
          command: ['/bin/sh', '-c']
          args: ['sed -i -- ''s/broker.id=0/broker.id=3/g'' /home/kafka/kafka/config/server.properties && sed -i -- ''s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/g'' /home/kafka/kafka/config/server.properties && /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties ']
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "kafka-4"
      labels: 
        name: "kafka"
        server-id: "1"
    spec: 
      containers: 
        - name: "kafka"
          image: "registry.docker.company.com:5000/company/kafka"
          #env: 
          #  - name: "BROKERID"
          #    value: "1"
          ports: 
            - containerPort: 9092
          command: ['/bin/sh', '-c']
          args: ['sed -i -- ''s/broker.id=0/broker.id=4/g'' /home/kafka/kafka/config/server.properties && sed -i -- ''s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/g'' /home/kafka/kafka/config/server.properties && /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties ']
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "kafka-5"
      labels: 
        name: "kafka"
        server-id: "1"
    spec: 
      containers: 
        - name: "kafka"
          image: "registry.docker.company.com:5000/company/kafka"
          #env: 
          #  - name: "BROKERID"
          #    value: "1"
          ports: 
            - containerPort: 9092
          command: ['/bin/sh', '-c']
          args: ['sed -i -- ''s/broker.id=0/broker.id=5/g'' /home/kafka/kafka/config/server.properties && sed -i -- ''s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/g'' /home/kafka/kafka/config/server.properties && /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties ']
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "kafka-6"
      labels: 
        name: "kafka"
        server-id: "1"
    spec: 
      containers: 
        - name: "kafka"
          image: "registry.docker.company.com:5000/company/kafka"
          #env: 
          #  - name: "BROKERID"
          #    value: "1"
          ports: 
            - containerPort: 9092
          command: ['/bin/sh', '-c']
          args: ['sed -i -- ''s/broker.id=0/broker.id=6/g'' /home/kafka/kafka/config/server.properties && sed -i -- ''s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/g'' /home/kafka/kafka/config/server.properties && /home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties ']
```

### Deploy kafka cluster in Kubernetes Cluster
##### Create Kubernetes List: Service and Pods

```bash
kubectl create -f kafka-cluster-list.yaml

kubectl get pods 
kafka-1             1/1       Running   0          43m
kafka-2             1/1       Running   0          43m
kafka-3             1/1       Running   0          43m
kafka-4             1/1       Running   0          43m
kafka-5             1/1       Running   0          43m
kafka-6             1/1       Running   0          43m
```

### Deploy kafka cluster endpoint in Kubernetes Cluster
##### Create Kubernetes Endpoints: kafka-endpoint.json
```yaml
{
    "kind": "Endpoints",
    "apiVersion": "v1",
    "metadata": {
        "name": "kafka"
    },
    "subsets": [
        {
            "addresses": [
                { "IP": "172.23.87.5" },
                { "IP": "172.23.86.8" },
                { "IP": "172.23.11.5" },
                { "IP": "172.23.20.5" },
                { "IP": "172.23.60.6" },
                { "IP": "172.23.98.6" }
            ],           
            "ports": [
                { "name": "9092", "port": 9092 }
            ]
        }
    ]
}

kubectl create -f kafka-endpoint.json

kubectl get ep
NAME                      ENDPOINTS
kafka                     172.23.11.5:9092,172.23.20.5:9092,172.23.60.6:9092 + 3 more...
```

### Deploye Zookeeper Service in Kubernetes Cluster
##### Create Kubernetes Service: kafka-service.json

```yaml
cat kafka-service.json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "kafka",
        "labels": {
           "name": "kafka"
        }
    },
    "spec": {
        "ports": [
            {
	    	"name": "9092",
                "protocol": "TCP",
                "port": 9092,
                "targetPort": 9092
            }
        ]
    }
}

kubectl create -f kafka-service.json

kubectl get svc
kafka                     name=kafka                                <none>                                192.168.3.192   9092/TCP
```

-------------------------------------------------------------------------------------------

### Test kafka cluster
##### Use the outbrain/kafkacli 
##### More Info can be acquired at https://github.com/outbrain/kafkacli
##### Get pre-build-binariess: https://github.com/outbrain/kafkacli/releases
##### Also, you can Download it as:
-----------------------------------------------------------------------------------------------------------------------


### Yeah~ It's work~~~~~

### Thanks to @Outbrain @fabric8
