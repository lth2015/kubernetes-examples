Use Memcached in Kubernetes Cluster
================

### Deploy Memcached 

### Install Memcached
##### sudo apt-get install -y memcached
----

### Bind all address
##### Edit mysql configuration
```bash
sed -i 's/-l 127\.0\.0\.1/-l 0.0.0.0/' /etc/memcached.conf
```

##### Restart memcached service
```bash
service memcached restart
```

##### Test connection by remote client
```bash
telnet 172.21.1.11 11211
```

### Deploy Memcached Endpoint
##### Edit memcached-endpoint.json
```json 
{
    "kind": "Endpoints",
    "apiVersion": "v1",
    "metadata": {
        "name": "memcached"
    },
    "subsets": [
        {
            "addresses": [
                { "IP": "172.21.1.11" }
            ],
            "ports": [
                { "port": 11211 }
            ]
        }
    ]
}
```
[Download]("memcached-endpoint.json")

---------------------------------------

### Deploy Memcached Service
##### Edit memcached-service.json
```json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "memcached",
        "labels": {
           "name": "memcached"
        }
    },
    "spec": {
        "ports": [
            {
                "protocol": "TCP",
                "port": 11211,
                "targetPort": 11211 
            }
        ]
    }
}
```
[Download file]("memcached-service.json")

##### Create memcached-endpoint.json
```bash
kubectl create -f memcached-endpoint.json

NAME            ENDPOINTS
kubernetes      172.21.1.11:6443
memcached       172.21.1.11:11211
```

##### Create memcached-service.json
```bash
kubectl create -f memcached-service.json

NAME            LABELS                                    SELECTOR           IP(S)           PORT(S)
kubernetes      component=apiserver,provider=kubernetes   <none>             192.168.3.1     443/TCP
memcached       name=memcached                            <none>             192.168.3.178   11211/TCP
```

### Test Memcached

##### Use mysql cli
```bash
telnet 192.168.3.178 11211
```

##### Use service discovery
```bash
kubectl exec busybox -- nslookup mysql
Server:    192.168.3.10
Address 1: 192.168.3.10

Name:      memcached
Address 1: 192.168.3.178
```

### It's OK ~~~~~~~~~~
