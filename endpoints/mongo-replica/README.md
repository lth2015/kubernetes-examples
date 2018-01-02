Use MongoDB Replica Set in Kubernetes Cluster
================

### Deploy Mongodb Replica Set

##### Mongodb document: https://docs.mongodb.org/manual/installation/
----

### Deploy Mongodb Replica Set access endpoint
##### Edit mongo-replica-endpoint.yaml
```json
{
	"kind": "Endpoints",
	"apiVersion": "v1",
	"metadata": {
		"name": "mongo-replica"
	},
	"subsets": [
	{
		"addresses": [
		{ "IP": "172.21.1.11" }
		],
			"ports": [
			{ "port": 27017 }
		]
	}
	]
}
```
[Download]("mongo-replica-endpoint.json")

##### Create endpoint in Kubernetes Cluster 
```bash 
kubectl create -f mongo-replica-endpoint.json

kubectl get ep
NAME            ENDPOINTS
mongo-replica   172.21.1.11:27017
```

---------------------------------------

### Deploy MongoDB Replica Set Service
##### Edit mongo-replica-service.json
```json
{
	"kind": "Service",
		"apiVersion": "v1",
		"metadata": {
			"name": "mongo-replica",
			"labels": {
				"name": "mongo-replica"
			}
		},
		"spec": {
			"ports": [
			{
				"protocol": "TCP",
				"port": 27017,
				"targetPort": 27017
			}
			]
		}
}
```
[Download file]("mongo-replica-service.json")

##### Create mongo-replica-service.json
```bash
kubectl create -f mongo-replica-service.json

	kubectl get svc
NAME            LABELS                                    SELECTOR   IP(S)          PORT(S)
	mongo-replica   name=mongo-replica                        <none>     192.168.3.81   27017/TCP
	```

### Test Mongodb Replica Set Service

##### Use mongo cli
	```bash
	mongo 192.168.3.81
	```

##### Use service discovery
	```bash
	kubectl exec busybox -- nslookup mongo-replica
	Server:    192.168.3.10
	Address 1: 192.168.3.10

	Name:      mongo-replica
	Address 1: 192.168.3.81
	```

### Official Document: How to use Endpoints and Service in kubernetes


#### Services without selectors

##### Services generally abstract access to Kubernetes Pods, but they can also abstract other kinds of backends. For example: You want to have an external database cluster in production, but in test you use your own databases. You want to point your service to a service in another Namespace or on another cluster. You are migrating your workload to Kubernetes and some of your backends run outside of Kubernetes. In any of these scenarios you can define a service without a selector:

```json
{
	"kind": "Service",
		"apiVersion": "v1",
		"metadata": {
			"name": "my-service"
		},
		"spec": {
			"ports": [
			{
				"protocol": "TCP",
				"port": 80,
				"targetPort": 9376
			}
			]
		}
}
```

###### Because this has no selector, the corresponding Endpoints object will not be created. You can manually map the service to your own specific endpoints:

```json
{
	"kind": "Endpoints",
		"apiVersion": "v1",
		"metadata": {
			"name": "my-service"
		},
		"subsets": [
		{
			"addresses": [
			{ "IP": "1.2.3.4" }
			],
				"ports": [
				{ "port": 80 }
			]
		}
	]
}
```

#Accessing a Service without a selector works the same as if it had selector. The traffic will be routed to endpoints defined by the user (1.2.3.4:80 in this example).



### It's OK ~~~~~~~~~~
