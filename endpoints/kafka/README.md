Use Zookeeper Cluster in Kubernetes Cluster
================

### Deploy Zookeeper Cluster

### Install Zookeeper
##### More details displayed on: https://github.com/lth2015/kubernetes-examples/tree/master/zookeeper
--------------------------------------------------------------------------------------


### Deploy Zookeeper Endpoint
##### Edit zookeeper-endpoint.json
```json 
{
    "kind": "Endpoints",
    "apiVersion": "v1",
    "metadata": {
        "name": "zookeeper"
    },
    "subsets": [
        {
            "addresses": [
                { "IP": "172.16.49.16" },
                { "IP": "172.16.49.17" },
                { "IP": "172.16.78.46" }
            ],
            "ports": [
                { "name": "2181", "port": 2181 },
                { "name": "2888", "port": 2888 },
                { "name": "3888", "port": 3888 }
            ]
        }
    ]
}
```
[Download]("zookeeper-endpoint.json")

--------------------------------------------------------------------------------------

### Deploy Zookeeper Service
##### Edit zookeeper-service.json
```json
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
```
[Download file]("zookeeper-service.json")

##### Create zookeeper-endpoint.json
```bash
kubectl create -f zookeeper-endpoint.json

kubectl get ep
NAME                  ENDPOINTS
golang-demo-service   <none>
kubernetes            10.254.7.106:6443
zookeeper             172.16.49.16:2888,172.16.49.17:2888,172.16.78.46:2888 + 6 more...
zookeeper-1           172.16.49.16:3888,172.16.49.16:2888,172.16.49.16:2181
zookeeper-2           172.16.49.17:3888,172.16.49.17:2888,172.16.49.17:2181
zookeeper-3           172.16.78.46:3888,172.16.78.46:2888,172.16.78.46:2181
```

##### Create zookeeper-service.json
```bash
kubectl create -f zookeeper-service.json

kubectl get svc
```
NAME                  LABELS                                    SELECTOR          IP(S)           PORT(S)
golang-demo-service   <none>                                    app=golang-demo   192.168.3.110   8888/TCP
kubernetes            component=apiserver,provider=kubernetes   <none>            192.168.3.1     443/TCP
zookeeper             name=zookeeper                            <none>            192.168.3.91    2181/TCP
                                                                                                  2888/TCP
                                                                                                  3888/TCP
zookeeper-1           name=zookeeper-1                          server-id=1       192.168.3.20    2181/TCP
                                                                                                  2888/TCP
                                                                                                  3888/TCP
zookeeper-2           name=zookeeper-2                          server-id=2       192.168.3.115   2181/TCP
                                                                                                  2888/TCP
                                                                                                  3888/TCP
zookeeper-3           name=zookeeper-3                          server-id=3       192.168.3.198   2181/TCP
                                                                                                  2888/TCP
                                                                                                  3888/TCP

### Test Zookeeper Cluster

##### Use zookeeper cli
```bash
zookeepercli
zookeepercli --servers zookeeper -c create /demo hello
zookeepercli --servers zookeeper --format=txt -c get /demo
zookeepercli --servers zookeeper --format=json -c get /demo
zookeepercli --servers zookeeper -c exists /demo
zookeepercli --servers zookeeper -c set /demo world
zookeepercli --servers zookeeper --format=json -c get /demo
zookeepercli --servers zookeeper -c create /demo  "path placeholder"
zookeepercli --servers zookeeper -c create /demo_only/key1 "value1"
zookeepercli --servers zookeeper -c create /demo_only "value1"
zookeepercli --servers zookeeper -c create /demo_only/key1 "value1"
zookeepercli --servers zookeeper -c create /demo_only/key2 "value2"
zookeepercli --servers zookeeper -c create /demo_only/key3 "value3"
zookeepercli --servers zookeeper -c ls /demo_only
zookeepercli --servers zookeeper -c ls /demo_only --format=json
zookeepercli --servers zookeeper --format=json -c ls /demo_only 
zookeepercli --servers zookeeper -c delete /demo_only
zookeepercli --servers zookeeper -c delete /demo_only/key1
zookeepercli --servers zookeeper -c delete /demo_only/key2
zookeepercli --servers zookeeper -c delete /demo_only/key3
zookeepercli --servers zookeeper --format=json -c ls /demo_only 
zookeepercli --servers zookeeper -c delete /demo_only
zookeepercli --servers zookeeper -c creater "/demo_only/child/key1" "val1"
zookeepercli --servers zookeeper -c creater "/demo_only/child/key2" "val2"
zookeepercli --servers zookeeper --format=json -c ls /demo_only 
zookeepercli --servers zookeeper --format=json -c get /demo_only
zookeepercli --servers zookeeper --format=json -c get /demo_only/child/key1
zookeepercli --servers zookeeper --format=json -c get /demo_only/child/key2
zookeepercli --servers zookeeper --format=json -c lsr "/demo_only"
zookeepercli --servers zookeeper --format=json -c lsr "/demo_only"
zookeepercli --servers zookeeper --format=json -c  create /demo_only some_value
zookeepercli --servers zookeeper --format=json -c get /demo_only 
 ```

##### Use service discovery
```bash
kubectl exec busybox -- nslookup zookeeper
server:    192.168.3.10
Address 1: 192.168.3.10

Name:      zookeeper
Address 1: 192.168.3.81
```

### Yeah! It's OK ~~~~~~~~~~
