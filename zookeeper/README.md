Use Zookeeper Cluster in Kubernetes Cluster
=========================

### Pull fabric8/zookeeper image from docker hub
##### Tag and Push fabric8/zookeeper to local docker registry
```bash
docker pull fabric8/zookeeper 
docker tag fabric8/zookeeper registry.docker.company.com:5000/company/zookeeper
docker push registry.docker.company.com:5000/company/zookeeper
```

### Deploy zookeeper cluster
#### Edit the zookeeper-cluster-list.yaml
```yaml
kind: "List"
apiVersion: "v1"
id: "zookeper"
items: 
  - kind: "Service"
    apiVersion: "v1"
    metadata: 
      name: "zookeeper-1"
      labels: 
        name: "zookeeper-1"
    spec: 
      ports: 
        - name: "client"
          port: 2181
          targetPort: 2181
        - name: "followers"
          port: 2888
          targetPort: 2888
        - name: "election"
          port: 3888
          targetPort: 3888
      selector: 
        server-id: "1"
  - kind: "Service"
    apiVersion: "v1"
    metadata: 
      name: "zookeeper-2"
      labels: 
        name: "zookeeper-2"
    spec: 
      ports: 
        - name: "client"
          port: 2181
          targetPort: 2181
        - name: "followers"
          port: 2888
          targetPort: 2888
        - name: "election"
          port: 3888
          targetPort: 3888
      selector: 
        server-id: "2"
  - kind: "Service"
    apiVersion: "v1"
    metadata: 
      name: "zookeeper-3"
      labels: 
        name: "zookeeper-3"
    spec: 
      ports: 
        - name: "client"
          port: 2181
          targetPort: 2181
        - name: "followers"
          port: 2888
          targetPort: 2888
        - name: "election"
          port: 3888
          targetPort: 3888
      selector: 
        server-id: "3"
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "zookeeper-1"
      labels: 
        name: "zookeeper"
        server-id: "1"
    spec: 
      containers: 
        - name: "server"
          image: "registry.docker.company.com:5000/company/zookeeper"
          env: 
            - name: "SERVER_ID"
              value: "1"
            - name: "MAX_SERVERS"
              value: "3"
          ports: 
            - containerPort: 2181
            - containerPort: 2888
            - containerPort: 3888
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "zookeeper-2"
      labels: 
        name: "zookeeper"
        server-id: "2"
    spec: 
      containers: 
        - name: "server"
          image: "registry.docker.company.com:5000/company/zookeeper"
          env: 
            - name: "SERVER_ID"
              value: "2"
            - name: "MAX_SERVERS"
              value: "3"
          ports: 
            - containerPort: 2181
            - containerPort: 2888
            - containerPort: 3888
  - kind: "Pod"
    apiVersion: "v1"
    metadata: 
      name: "zookeeper-3"
      labels: 
        name: "zookeeper"
        server-id: "3"
    spec: 
      containers: 
        - name: "server"
          image: "registry.docker.company.com:5000/company/zookeeper"
          env: 
            - name: "SERVER_ID"
              value: "3"
            - name: "MAX_SERVERS"
              value: "3"
          ports: 
            - containerPort: 2181
            - containerPort: 2888
            - containerPort: 3888
```

### Deploy zookeeper cluster in Kubernetes Cluster
##### Create Kubernetes List: Service and Pods

```bash
kubectl create -f zookeeper-cluster-list.yaml
NAME                  LABELS                                    SELECTOR          IP(S)           PORT(S)
zookeeper-1           name=zookeeper-1                          server-id=1       192.168.3.20    2181/TCP
												  2888/TCP 
												  3888/TCP
zookeeper-2           name=zookeeper-2                          server-id=2       192.168.3.115   2181/TCP
												  2888/TCP
												  3888/TCP 
zookeeper-3           name=zookeeper-3                          server-id=3       192.168.3.198   2181/TCP 
												  2888/TCP 
												  3888/TCP 
```

### Deploy zookeeper cluster endpoint in Kubernetes Cluster
##### Create Kubernetes Endpoints: zookeeper-endpoint.json
```yaml
cat zookeeper-endpoint.json
{
    "kind": "Endpoints",
    "apiVersion": "v1",
    "metadata": {
        "name": "zookeeper"
    },
    "subsets": [
        {
            "addresses": [
                { "IP": "172.23.89.3" },
                { "IP": "172.23.5.5" },
                { "IP": "172.23.87.4" },
                { "IP": "172.23.98.5" },
                { "IP": "172.23.11.4" }
            ],
            "ports": [
                { "name": "2181", "port": 2181 },
                { "name": "2888", "port": 2888 },
                { "name": "3888", "port": 3888 }
            ]
        }
    ]
}

kubectl create -f zookeeper-endpoint.json

kubectl get ep
zookeeper-1               172.23.89.3:3888,172.23.89.3:2888,172.23.89.3:2181
zookeeper-2               172.23.5.5:3888,172.23.5.5:2888,172.23.5.5:2181
zookeeper-3               172.23.87.4:3888,172.23.87.4:2888,172.23.87.4:2181
zookeeper-4               172.23.98.5:3888,172.23.98.5:2888,172.23.98.5:2181
zookeeper-5               172.23.11.4:3888,172.23.11.4:2888,172.23.11.4:2181
```

### Deploye Zookeeper Service in Kubernetes Cluster
##### Create Kubernetes Service: zookeeper-service.json
```yaml
cat zookeeper-service.json

{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "zookeeper",
        "labels": {
           "name": "zookeeper"
        }
    },
    "spec": {
        "ports": [
            {
	    	"name": "2181",
                "protocol": "TCP",
                "port": 2181,
                "targetPort": 2181
            },
            {
	    	"name": "2888",
                "protocol": "TCP",
                "port": 2888,
                "targetPort": 2888
            },
            {
	    	"name": "3888",
                "protocol": "TCP",
                "port": 3888,
                "targetPort": 3888
            }
        ]
    }
}

kubectl create -f zookeeper-service.json
kubectl get svc
zookeeper                 name=zookeeper                            <none>                                192.168.3.128   2181/TCP
```

-------------------------------------------------------------------------------------------

### Test zookeeper cluster
##### Use the outbrain/zookeepercli 
##### More Info can be acquired at https://github.com/outbrain/zookeepercli
##### Get pre-build-binariess: https://github.com/outbrain/zookeepercli/releases
##### Also, you can Download it as:
[Download]("zookeepercli")

##### Type the commands in your console, btw, you should add zhe k8s svc to your host
```bash
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo hello
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=txt -c get /demo
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c get /demo
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c exists /demo
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c set /demo world
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c get /demo
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo  "path placeholder"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo_only/key1 "value1"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo_only "value1"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo_only/key1 "value1"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo_only/key2 "value2"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c create /demo_only/key3 "value3"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c ls /demo_only
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c ls /demo_only --format=json
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c ls /demo_only 
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c delete /demo_only
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c delete /demo_only/key1
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c delete /demo_only/key2
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c delete /demo_only/key3
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c ls /demo_only 
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c delete /demo_only
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c creater "/demo_only/child/key1" "val1"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 -c creater "/demo_only/child/key2" "val2"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c ls /demo_only 
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c get /demo_only
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c get /demo_only/child/key1
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c get /demo_only/child/key2
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c lsr "/demo_only"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c lsr "/demo_only"
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c create /demo_only some_value
zookeepercli --servers zookeeper-1,zookeeper-2,zookeeper-3 --format=json -c get /demo_only
#ls kafka broker
./zookeepercli --servers 192.168.3.209,192.168.3.186,192.168.3.171,192.168.3.195,192.168.3.15 -c ls /brokers/ids
```

-----------------------------------------------------------------------------------------------------------------------


### Yeah~ It's work~~~~~

### Thanks to @Outbrain @fabric8
