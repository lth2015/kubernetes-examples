Kubernetes Official Mongodb Example Use Local NFS Server
================

Expose a NFS Server with docker
----
##### Use docker-nfs-server as a nfs-server 
##### Expose a shared directory witch contect the nfs-data-device use docker -v options
##### U should notice the --privileged=true option, its' required
```bash
docker run -d --restart=always --name mongo -v /mnt/nfs/mongo:/tmp --privileged=true company/docker-nfs-server /tmp
```

##### Get the IPAdress of nfs-server
```bash
docker inspect nfs-server | grep IPAdress

"IPAddress": "172.17.0.30",
"SecondaryIPAddresses": null,
```

##### Install nfs-common on your host machine, then test
```bash
showmount -e 172.17.0.30

Export list for 172.17.0.30:
/tmp *

```
##### Test nfs mount
```bash 
mkdir /nfs
mount -t nfs 172.17.0.30:/tmp /nfs
umount /nfs
rm -fr /nfs
```

Use NFS Server in K8s Cluster
-------------------------

### Note: You expose the 172.17.0.30:/tmp derectory as a nfs-mount-point, so, in k8s pods, you should mount the /tmp as the mount point

##### Create the testing pod
```bash
kubectl create -f mongo-controller.yaml

kubectl create -f mongo-service.yaml

kubectl get svc
NAME         LABELS                                    SELECTOR     IP(S)           PORT(S)
mongo        name=mongo                                name=mongo   192.168.3.163   27017/TCP

##### Test the nginx service
```bash
mongo 192.168.3.163:27017
a = {"name":"litanhua"}
db.test.save(a)
quit()
```

