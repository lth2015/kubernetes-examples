Kubernetes Resource Quotas
-------------------------------------------

# Understanding Resource Quotas

### When several users or teams share a cluster with a fixed number of nodes, there is a concern that one team could use more than its fair share of resources. Mor details: http://kubernetes.io/docs/admin/resourcequota/

### Examples
##### In a cluster with a capacity of 32 GiB RAM, and 16 cores, let team A use 20 Gib and 10 cores, let B use 10GiB and 4 cores, and hold 2GiB and 2 cores in reserve for future allocation.
##### Limit the “testing” namespace to using 1 core and 1GiB RAM. Let the “production” namespace use any amount.

### Enabling Resource Quota
##### It is enabled when the apiserver --admission-control= flag has ResourceQuota as one of its arguments.

### Viewing and Setting Quotas
##### Kubectl supports creating, updating, and viewing quotas:
```bash
kubectl namespaces myspace
cat <<EOF > quota.json
{
  "apiVersion": "v1",
  "kind": "ResourceQuota",
  "metadata": {
    "name": "quota",
    "namespace": "demos"
  },
  "spec": {
    "hard": {
      "memory": "1Gi",
      "cpu": "20",
      "pods": "10",
      "services": "5",
      "replicationcontrollers":"20",
      "resourcequotas":"1"
    }
  }
}
EOF

kubectl create -f quota.json

kubectl get quota --namespace=demos
NAME      AGE
quota     1m

kubectl describe quota quota --namespace=demos
Name:			quota
Namespace:		demos
Resource		Used	Hard
--------		----	----
cpu			0	20
memory			0	1Gi
pods			0	10
replicationcontrollers	0	20
resourcequotas		1	1
services		0	5
```

### Quota and Cluster Capacity
#### Resource Quota objects are independent of the Cluster Capacity. They are expressed in absolute units. So, if you add nodes to your cluster, this does not automatically give each namespace the ability to consume more resources.

##### More details: http://kubernetes.io/docs/admin/resourcequota/walkthrough/
