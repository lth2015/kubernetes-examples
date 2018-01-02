Redis主从集群
==============================

Redis镜像是在官方标准的3.2.5镜像基础上构建，为了提高Redis镜像本身的可维护性，我们仅仅在它的配置文件上做修改。


#### Redis Master
----------------------------

需要填写两个环境变量：

* MASTERAUTH

* PASSWORD


要求MASTERAUTH,与PASSWORD一致

#### Redis Slave
----------------------------

需要填写两个环境变量：

* MASTERIP

* MASTERPORT

* MASTERAUTH

* PASSWORD

Slave需要配置Master的地址和端口，也需要填写与Master通信的访问密码。

使用容器云平台发布时，Master-Slave的相关参数一定保持一致。


#### Testing
----------------------------

##### 使用Docker命令发布测试
----------------------------

* 创建master节点

```bash
cd master
make build
make test
```

* 创建slave节点，另开一个窗口

```bash
cd slave
make build
make test
```

* 开始测试

另起一个窗口，找到redis-master的IP地址，假如为192.168.3.186，使用telnet设置一个变量的值：

```bash
Trying 192.168.3.186...
Connected to 192.168.3.186.
Escape character is '^]'.
AUTH password
+OK
set hello 'you'
+OK
get hello 
$3
you
quit
+OK
Connection closed by foreign host.
```

再起一个窗口，找到redis-slave的IP地址，假如为192.168.3.170，使用telnet读取刚刚设定的变量的值：

```bash
Trying 192.168.3.170...
Connected to 192.168.3.170.
Escape character is '^]'.
AUTH password
+OK
get hello 
$3
you
quit
+OK
Connection closed by foreign host.
```

##### 使用
----------------------------

* 登录容器云平台，创建发布模板

* 先创建redis-master模板

* 再创建redis-slave模板

* 使用绿色通道发布一个一主两从的redis集群

* 发布成功后，使用上述方面进行测试

#### 说明
----------------------------

* 容器化的主从集群只提供缓存使用场景

* 应用程序不要强依赖Redis缓存，如果Redis集群出现问题，应用程序从数据库中取值

* 容器化的集群不能跨机房搭建，推荐每个项目使用自己的Redis集群，并且在每个数据中心分别部署，应用程序不跨机房调用


