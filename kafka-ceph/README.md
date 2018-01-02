Use Kafka cluster in Kubernetes cluster
================

### Why use Pod not Replicationcontroller?
----
##### Kafka通过BROKER_ID来识别自身，在注册到zookeeper中时，注册的名字默认为容器的主机名，如果用rc的话，pod的名称是带上一定的前缀随机生成的，
##### 容器中其他节点不能通过这个随机生成的hostname来寻址，解决方案是：在容器启动时，将容器的eth0的ip作为kafka注册到zookeeper集群中的主机名，
##### 这样，其它kafka节点和覆盖网络内部的组件就可以访问kafka，并能写入数据。
---- 
##### 在这样做之前，kafka集群可以创建topic，也可显示、列出topic，producer不能写入，原因是kafka的配置中(server.properties)中要配置host.name和advertised.port,问题类似[Kafka Producer Can't Fetch Metadata Problem](stackoverflow.com/questions/30606447/kafka-consumer-fetching-metadata-for-topics-failed)
##### 由于brokerid等都是在容器创建后、kafka启动前用入口脚本替换相应的配置，还有ceph存储写入的问题，所以我们使用同一的RC，对于Pod我们也可以设置自动重启，所以，对已一个的Pod，RC和Pod从这点说没有什么区别
##### Pod的metadata的name就是pod容器运行后的hostname

##### Edit kafka-pods/kafka-1-pod.json
```json
{
  "spec": {
    "volumes": [
      {
        "rbd": {
          "readOnly": false,
          "fsType": "xfs",
          "secretRef": {
            "name": "ceph-secret"
          },
          "user": "admin",
          "image": "kafka-1",
          "pool": "rbd",
          "monitors": [
            "10.149.149.3:6789"
          ]
        },
        "name": "kafka-1"
      }
    ],
    "restartPolicy": "Always",
    "containers": [
      {
        "volumeMounts": [
          {
            "name": "kafka-1",
            "mountPath": "/tmp/kafka-logs"
          }
        ],
        "resources": {
          "limits": {
            "memory": "20480M",
            "cpu": "20"
          },
          "requests": {
            "memory": "8192M",
            "cpu": "10"
          }
        },
        "args": [
          "sed -i -- 's/broker.id=0/broker.id=1/g' /home/kafka/config/server.properties &&  IP=`ifconfig eth0 |  grep 'inet addr:' | awk -F ':' '{print $2}' | awk '{print $1}'` && echo $IP &&  sed -i -- \"s/host.name=KAFKA/host.name=$IP/g\" /home/kafka/config/server.properties && sed -i -- 's/advertised.port=KAFKA/advertised.port=9092/g' /home/kafka/config/server.properties && sed -i -- 's/num.network.threads=3/num.network.threads=10/g' /home/kafka/config/server.properties && sed -i -- 's/num.io.threads=8/num.io.threads=20/g' /home/kafka/config/server.properties && sed -i -- 's/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181,zookeeper-4:2181,zookeeper-5:2181/g' /home//kafka/config/server.properties && /home/kafka/bin/kafka-server-start.sh /home/kafka/config/server.properties "
        ],
        "command": [
          "/bin/sh",
          "-c"
        ],
        "ports": [
          {
            "containerPort": 9092
          }
        ],
        "image": "registry.docker:5000/company/kafka:2.11-0.9.0",
        "name": "kafka-1"
      }
    ]
  },
  "metadata": {
    "name": "kafka-1",
    "labels": {
      "component": "kafka",
      "role": "kafka-1"
    }
  },
  "kind": "Pod",
  "apiVersion": "v1"
}
```
[Download]("kafka-pods/kafka-1-pod.json")

---------
##### Create kafka-1-pod.json
```bash
kubectl create -f kafka-1-pod.json
```
