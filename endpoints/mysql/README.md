Use MySQL Server in Kubernetes Cluster
================

### Deploy MySQL Server

### Install MySQL
##### sudo apt-get install -y mysql-server mysql-client
----

### User and Admission controll 
##### Create mysql user for test
```bash
mysql -uroot -p
mysql>use mysql
mysql>create user username identified by "password"
mysql>grant all on *.* to username;
mysql>flush privileges;
mysql>quit
```

### Bind all address
##### Edit mysql configuration
```bash
sed -i 's/bind-address/# bind-address/' /etc/mysql/my.cnf
```

##### Restart mysql service
```bash
service mysql restart
```

##### Test connection by remote client
```bash
mysql -h yourhost -u username -p
```

### Deploy MySQL Endpoint
##### Edit mysql-endpoint.json
```json 
{
    "kind": "Endpoints",
    "apiVersion": "v1",
    "metadata": {
        "name": "mysql"
    },
    "subsets": [
        {
            "addresses": [
                { "IP": "172.21.1.11" }
            ],
            "ports": [
                { "port": 3306 }
            ]
        }
    ]
}
```
[Download]("mysql-endpoint.json")

---------------------------------------

### Deploy MySQL Service
##### Edit mysql-service.json
```json
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "mysql",
        "labels": {
           "name": "mysql"
        }
    },
    "spec": {
        "ports": [
            {
                "protocol": "TCP",
                "port": 3306,
                "targetPort": 3306 
            }
        ]
    }
}
```
[Download file]("mysql-service.json")

##### Create mysql-endpoint.json
```bash
kubectl create -f mysql-endpoint.json

kubectl get ep
NAME            ENDPOINTS
kubernetes      172.21.1.11:6443
mysql           172.21.1.11:3306
```

##### Create mysql-service.json
```bash
kubectl create -f mysql-service.json

NAME            LABELS                                    SELECTOR           IP(S)           PORT(S)
kubernetes      component=apiserver,provider=kubernetes   <none>             192.168.3.1     443/TCP
mysql           name=mysql                                <none>             192.168.3.197   3306/TCP
```

### Test MySQL

##### Use mysql cli
```bash
mysql -h 192.168.3.197  -u username -p
```

##### Use service discovery
```bash
kubectl exec busybox -- nslookup mysql
Server:    192.168.3.10
Address 1: 192.168.3.10

Name:      mysql
Address 1: 192.168.3.81
```

### It's OK ~~~~~~~~~~
