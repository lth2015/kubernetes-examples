Use Ceph as centralized Storage
=======================================================================

### Pre Requisite
##### Install Ceph on the Kubernetes host/master. For example, on ubuntu 14.04
```bash
#apt-get install ceph ceph-common
```

**Important: the version of ceph-common must be >= 0.87.**
**Make sure: the rbd-module is loaded in OS, If not, run this command:**
```bash
modprobe rbd
```
##### Check the kernel module angine:
```bash
lsmod | grep rbd
rbd                    73728  4 
libceph               241664  2 rbd,ceph
```

##### Pull ceph/demo images
```bash
docker pull ceph/demo
```

##### Set up your Ceph environment
```bash
cat run.sh
#!/bin/bash
docker run -d --net=host -v /var/lib/ceph:/var/lib/ceph -v /etc/ceph:/etc/ceph -e MON_IP=172.21.1.11 -e CEPH_NETWORK=172.21.1.0/24 ceph/demo
```
[Download]("run.sh")

##### Serveral actions are not assumed by Kubernetes such as:
	+ RBD volume creation
	+ Filesystem on this volume
##### So let's do this first:
```bash
rbd create foo -s 1024
rbd map foo
mkfs.ext4 /dev/rdb0
rbd unmap /dev/rdb0
```

### Configure Kubernetes
##### Get your ceph.admin key and encode it in base64:
```bash
ceph auth get-key client.admin
AQANS0RWZFojGRAAFNSVh8e/oqYilvqKW3JBjw==
echo "AQANS0RWZFojGRAAFNSVh8e/oqYilvqKW3JBjw==" | base64
QVFBTlMwUldaRm9qR1JBQUZOU1ZoOGUvb3FZaWx2cUtXM0pCanc9PQo=
```

##### Edit ceph-secret.yaml with the base64 key
```bash
cat secret/ceph-secret.yaml

apiVersion: v1
kind: Secret
metadata:
  name: ceph-secret
data:
  key: QVFBTlMwUldaRm9qR1JBQUZOU1ZoOGUvb3FZaWx2cUtXM0pCanc9PQo=
```
[Download]("secret/ceph-secret.yaml")

##### Add the secret to Kubernetes
```bash
kubectl create -f secret/ceph-secret.yaml
kubectl get secret
NAME                        TYPE                                  DATA
ceph-secret                 Opaque                                1

```

##### Edit ubuntu-ceph.json to test ceph storage
```json
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "name": "ubuntu-ceph"
    },
    "spec": {
        "containers": [
            {
                "name": "ubuntu-ceph",
                "image": "registry.test.com:5000/ubuntu-ceph",
                "volumeMounts": [
                    {
                        "mountPath": "/data",
                        "name": "ceph"
                    }
                ]
            }
        ],
        "volumes": [
            {
                "name": "ceph",
                "rbd": {
                    "monitors": [
        						"172.21.1.11:6789"
    				 ],
                    "pool": "rbd",
                    "image": "foo",
                    "user": "admin",
                    "secretRef": {
						  "name": "ceph-secret"
					 },
                    "fsType": "ext4",
                    "readOnly": false 
                }
            }
        ]
    }
}
```

###### BTW, Build the docker images, you can see a Dockerfile in the demo Directory

##### Create the ubuntu-ceph in Kubernetes Cluster
```bash
kubectl create -f ubuntu-ceph.json
```

### Test Ceph Storage
##### Check the device status on the Kubernetes host:
```bash
rbd showmapped
id pool image snap device    
0  rbd  foo   -    /dev/rbd0 
```

##### The image got mapped, now we check where this iamge got mounted
```bash
mount | grep kube | grep rbd
/dev/rbd0 on /var/lib/kubelet/plugins/kubernetes.io/rbd/rbd/rbd-image-foo type ext4 (rw)
/var/lib/kubelet/plugins/kubernetes.io/rbd/rbd/rbd-image-foo on /var/lib/kubelet/pods/7fdc4ac4-8922-11e5-8c7c-44a84240716a/volumes/kubernetes.io~rbd/rbdpd type none (ro)
```

##### Check the Ceph Storage work
```bash
kubectl exec ubuntu-ceph -- touch /data/aaa
kubectl delete -f ubuntu-ceph.json
kubectl create -f ubuntu-ceph.json
kubectl exec ubuntu-ceph -- ls /data
```

##### Mount the rbd in your host machine
```bash
kubectl delete -f ubuntu-ceph.json
rbd showmapped
id pool image snap device    
0  rbd  foo   -    /dev/rbd0 
1  rbd  web   -    /dev/rbd1 
mount /dev/rbd0 /mnt/
cd /mnt && ls && cat aaa
```



### Yeah~ It's work~~~~~


##### See more info: 
###### [https://ceph.com/planet/bring-persistent-storage-for-your-containers-with-krbd-on-kubernetes/]
###### [http://kubernetes.io/v1.0/examples/rbd/README.html]

