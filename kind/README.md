


## Installation

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /some-dir-in-your-PATH/kind
```

* Checkout [releases](https://github.com/kubernetes-sigs/kind/releases) page. 


## Get Kind version
```bash
$ kind --version
kind version 0.9.0
```


## Creating a Cluster

```bash
$ kind create cluster --name my-awesome-cluster
Creating cluster "my-awesome-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.19.1) 🖼 
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
Set kubectl context to "kind-my-awesome-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-my-awesome-cluster

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
```

A cluster with *one* node (master) has been deployed, but if you wante multi-nodes (master and workers), follow the step bellow:

## Multi nodes

Create this file named as `cluster-config.yaml`

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

Then run `kind create cluster` again using this configuration file:

```bash
$ kind create cluster --name my-awesome-cluster --config cluster-config.yaml 
Creating cluster "my-awesome-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.19.1) 🖼
 ✓ Preparing nodes 📦 📦 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
 ✓ Joining worker nodes 🚜 
Set kubectl context to "kind-my-awesome-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-my-awesome-cluster

Have a nice day! 👋
```

Check if worker nodes has been deployed:

```bash
$ kubectl get node
NAME                               STATUS   ROLES    AGE    VERSION
my-awesome-cluster-control-plane   Ready    master   116s   v1.19.1
my-awesome-cluster-worker          Ready    <none>   79s    v1.19.1
my-awesome-cluster-worker2         Ready    <none>   79s    v1.19.1
```


## Create first deployment

Creating namespace to our deployment:

```bash
$ kubectl create namespace frontend
namespace/frontend created

$ kubectl get ns frontend
NAME       STATUS   AGE
frontend   Active   10s
```

Creating a yaml file (We need to add container port):

```bash
$ kubectl create deployment my-web-site --image=nginx --dry-run -o yaml --namespace=frontend > my-web-site-deployment.yaml
```

Applying our deployment file

```bash
$ kubectl apply -f my-web-site-deployment.yaml 
deployment.apps/my-web-site created
```

It's has been deployed successfuly!

```bash
$ kubectl get deploy -n frontend
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
my-web-site   0/1     1            0           14s

$ kubectl get pod -n frontend
NAME                           READY   STATUS    RESTARTS   AGE
my-web-site-65c5555d84-9n4r4   1/1     Running   0          37s
```

Exposing deployment with `port-forward`

```
$ kubectl port-forward deployment/my-web-site :80 -n frontend
Forwarding from 127.0.0.1:44375 -> 80
Forwarding from [::1]:44375 -> 80
Handling connection for 44375
```

Making simple request with `curl`:

```
$ curl 127.0.0.1:44375
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

It's works!! 
