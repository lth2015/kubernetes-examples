# Nginx Ingress Controller

This is a nginx Ingress controller that uses [ConfigMap](https://github.com/kubernetes/kubernetes/blob/master/docs/proposals/configmap.md) to store the nginx configuration. See [Ingress controller documentation](../README.md) for details on how it works.


## What it provides?

- Ingress controller
- nginx 1.9.x with
- SSL support
- custom ssl_dhparam (optional). Just mount a secret with a file named `dhparam.pem`.
- support for TCP services (flag `--tcp-services-configmap`)
- custom nginx configuration using [ConfigMap](https://github.com/kubernetes/kubernetes/blob/master/docs/proposals/configmap.md)
- custom error pages. Using the flag `--custom-error-service` is possible to use a custom compatible [404-server](https://github.com/kubernetes/contrib/tree/master/404-server) image


## Requirements
- default backend [404-server](https://github.com/kubernetes/contrib/tree/master/404-server)



## Deploy the Ingress controller

First create a default backend:
```
$ kubectl create -f examples/default-backend.yaml
$ kubectl expose rc default-http-backend --port=80 --target-port=8080 --name=default-http-backend
```

Loadbalancers are created via a ReplicationController or Daemonset:

```
$ kubectl create -f examples/default/rc-default.yaml
```

## HTTP

First we need to deploy some application to publish. To keep this simple we will use the [echoheaders app](https://github.com/kubernetes/contrib/blob/master/ingress/echoheaders/echo-app.yaml) that just returns information about the http request as output
```
kubectl run echoheaders --image=gcr.io/google_containers/echoserver:1.3 --replicas=1 --port=8080
```

Now we expose the same application in two different services (so we can create different Ingress rules)
```
kubectl expose deployment echoheaders --port=80 --target-port=8080 --name=echoheaders-x
kubectl expose deployment echoheaders --port=80 --target-port=8080 --name=echoheaders-y
```

Next we create a couple of Ingress rules
```
kubectl create -f examples/ingress.yaml
```

we check that ingress rules are defined:
```
$ kubectl get ing
NAME      RULE          BACKEND   ADDRESS
echomap   -
          foo.bar.com
          /foo          echoheaders-x:80
          bar.baz.com
          /bar          echoheaders-y:80
          /foo          echoheaders-x:80
```

Before the deploy of the Ingress controller we need a default backend [404-server](https://github.com/kubernetes/contrib/tree/master/404-server)
```
kubectl create -f examples/default-backend.yaml
kubectl expose rc default-http-backend --port=80 --target-port=8080 --name=default-http-backend
```

Check NGINX it is running with the defined Ingress rules:

```
$ LBIP=$(kubectl get node `kubectl get po -l name=nginx-ingress-lb --template '{{range .items}}{{.spec.nodeName}}{{end}}'` --template '{{range $i, $n := .status.addresses}}{{if eq $n.type "ExternalIP"}}{{$n.address}}{{end}}{{end}}')
$ curl $LBIP/foo -H 'Host: foo.bar.com'
```

## TLS

You can secure an Ingress by specifying a secret that contains a TLS private key and certificate. Currently the Ingress only supports a single TLS port, 443, and assumes TLS termination. This controller supports SNI. The TLS secret must contain keys named tls.crt and tls.key that contain the certificate and private key to use for TLS, eg:

```
apiVersion: v1
data:
  tls.crt: base64 encoded cert
  tls.key: base64 encoded key
kind: Secret
metadata:
  name: testsecret
  namespace: default
type: Opaque
```

Referencing this secret in an Ingress will tell the Ingress controller to secure the channel from the client to the loadbalancer using TLS:

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: no-rules-map
spec:
  tls:
    secretName: testsecret
  backend:
    serviceName: s1
    servicePort: 80
```
Please follow [test.sh](https://github.com/bprashanth/Ingress/blob/master/examples/sni/nginx/test.sh) as a guide on how to generate secrets containing SSL certificates. The name of the secret can be different than the name of the certificate.

Check the [example](examples/tls/README.md)



#### Optimizing TLS Time To First Byte (TTTFB)

NGINX provides the configuration option [ssl_buffer_size](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_buffer_size) to allow the optimization of the TLS record size. This improves the [Time To First Byte](https://www.igvita.com/2013/12/16/optimizing-nginx-tls-time-to-first-byte/) (TTTFB). The default value in the Ingress controller is `4k` (nginx default is `16k`);


## Exposing TCP services

Ingress does not support TCP services (yet). For this reason this Ingress controller uses a ConfigMap where the key is the external port to use and the value is
`<namespace/service name>:<service port>`
It is possible to use a number or the name of the port.

The next example shows how to expose the service `example-go` running in the namespace `default` in the port `8080` using the port `9000`
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: tcp-configmap-example
data:
  9000: "default/example-go:8080"
```


Please check the [tcp services](examples/tcp/README.md) example

## Exposing UDP services

Since 1.9.13 NGINX provides [UDP Load Balancing](https://www.nginx.com/blog/announcing-udp-load-balancing/).

Ingress does not support UDP services (yet). For this reason this Ingress controller uses a ConfigMap where the key is the external port to use and the value is
`<namespace/service name>:<service port>`
It is possible to use a number or the name of the port.

The next example shows how to expose the service `kube-dns` running in the namespace `kube-system` in the port `53` using the port `53`
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: udp-configmap-example
data:
  53: "kube-system/kube-dns:53"
```


Please check the [udp services](examples/udp/README.md) example


## Custom NGINX configuration

Using a ConfigMap it is possible to customize the defaults in nginx.

Please check the [tcp services](examples/custom-configuration/README.md) example

```yaml

apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: nginx-ingress-lb
spec:
  template:
    metadata:
      labels:
        name: nginx-ingress-lb
    spec:
      containers:
      - image: gcr.io/google_containers/nginx-ingress-controller:0.4
        name: nginx-ingress-lb
        imagePullPolicy: Always
        livenessProbe:
          httpGet:
            path: /healthz
            port: 10249
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
        # use downward API
        env:
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
        ports:
        - containerPort: 80
          hostPort: 80
        - containerPort: 443
          hostPort: 4444
        args:
        - /nginx-ingress-controller
        - --default-backend-service=default/default-http-backend
```
