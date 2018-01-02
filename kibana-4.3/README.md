Use Dockerized-Kibana4.3.1 in Kubernetes Cluster
=================================================

### Download Kibana
##### Dowload the Kibana4.3.1 Linux x64 version
```bash
wget https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
tar -zxvf kibana-4.3.1-linux-x64.tar.gz
```

### Modify the kibana config file
#### Edit the kibana-4.3.1-linux-x64/config/kibana.yml
```bash
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
