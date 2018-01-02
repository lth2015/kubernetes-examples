Test Service Descovery Using Golang in Kubernetes Cluster
================

Deploy Kubernetes Official Example
----
##### Details: https://github.com/lth2015/kubernetes-examples/tree/master/kube-mongo-example
----
##### Get the Mongo-Service
```bash
kubectl get svc
NAME         LABELS                                    SELECTOR     IP(S)          PORT(S)
mongo-svc    name=mongo                                name=mongo   192.168.3.39   27017/TCP
```
##### Use the Mongo Service
```bash 
cat > test.go

package main

import (
	"fmt"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"log"
	"os"
)

type Person struct {
	Name  string
	Phone string
}

func main() {
	svc := os.Getenv("MONGO_SVC_SERVICE_HOST")
	port := os.Getenv("MONGO_SVC_SERVICE_PORT")
	fmt.Println("Server: ", svc, ", Port: ", port)

	session, err := mgo.Dial("mongo-svc.default")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	// Optional. Switch the session to a monotonic behavior.
	session.SetMode(mgo.Monotonic, true)

	c := session.DB("test").C("Person")
	err = c.Insert(&Person{"Boy", "+86 01 18987654321"},
		&Person{"Girl", "+86 01 18612345678"})
	if err != nil {
		log.Fatal(err)
	}

	result := Person{}
	err = c.Find(bson.M{"name": "Boy"}).One(&result)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Phone:", result.Phone)
	fmt.Println("Hello world!")
}
```
[Download file](test.go)

Build Binary Golang-file
-----
```bash
go build test.go
mv test bin/
```

Build Docker images
-------------------------
### You Can build it as company/go-test-dns images

##### Dockerfile
```bash
cat > Dockerfile

FROM ubuntu
ADD bin /usr/local/bin
RUN chmod +x /usr/local/bin
ENTRYPOINT ["/usr/local/bin/test"]
```
[Download file](Dockerfile)

##### Docker build
```bash
docker built -t company/go-test-dns .
```

##### Create a kubernetes yaml for Golang-Test
```bash
cat > go-test-dns-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: go-test-dns
labels:
  name: go-test-dns
spec:
  containers:
    - name: go-test-dns
      image: company/go-test-dns
```
[Download file](go-test-dns-pod.yaml)

### Run it in Kubernetes cluster
```bash
kubectl create -f go-test-dns-pod.yaml

kubectl logs go-test-dns

Server:  192.168.3.39 , Port:  27017
Phone: +86 01 18687654321
Hello world!

```
