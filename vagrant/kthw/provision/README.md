install docker


# generating ca
```console
vagrant@controlplane01:~$ mkdir -p certificates/ca
vagrant@controlplane01:~$ cd certificates/ca/
vagrant@controlplane01:~/certificates/ca$ openssl genrsa -out ca.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
............................................................................................................................++++
.....................................++++
vagrant@controlplane01:~/certificates/ca$ openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt -days 1000
Signature ok
subject=CN = KUBERNETES-CA
Getting Private key
```


# admin client
```console
vagrant@controlplane01:~/certificates/admin-client$ openssl genrsa -out admin.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
.....................................++++
..............++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/admin-client$ openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr
vagrant@controlplane01:~/certificates/admin-client$ openssl x509 -req -in admin.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out admin.crt -days 1000
Signature ok
subject=CN = admin, O = system:masters
Getting CA Private Key
```

# controller manager client cert
```console
vagrant@controlplane01:~/certificates/controller-manager-client$ openssl genrsa -out kube-controller-manager.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
........................................................................++++
.++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/controller-manager-client$ openssl req -new -key kube-controller-manager.key -subj "/CN=system:kube-controller-manager" -out kube-controller-manager.csr
vagrant@controlplane01:~/certificates/controller-manager-client$ openssl x509 -req -in kube-controller-manager.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out kube-controller-manager.crt -days 1000
Signature ok
subject=CN = system:kube-controller-manager
Getting CA Private Key
```

# kube-proxy-client
```console
vagrant@controlplane01:~/certificates/kube-proxy-client$ openssl genrsa -out kube-proxy.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
...............................................................................................................++++
...............................................................................................++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/kube-proxy-client$ openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy" -out kube-proxy.csr
vagrant@controlplane01:~/certificates/kube-proxy-client$ openssl x509 -req -in kube-proxy.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out kube-proxy.crt -days 1000
Signature ok
subject=CN = system:kube-proxy
Getting CA Private Key
```

# kube-scheduler-client
```console
vagrant@controlplane01:~/certificates/kube-scheduler-client$ openssl genrsa -out kube-scheduler.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
............++++
...++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/kube-scheduler-client$ openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler" -out kube-scheduler.csr
vagrant@controlplane01:~/certificates/kube-scheduler-client$ openssl x509 -req -in kube-scheduler.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out kube-scheduler.crt -days 1000
Signature ok
subject=CN = system:kube-scheduler
Getting CA Private Key
```

# kubernetes api server
```console
vagrant@controlplane01:~/certificates/kube-api-server$ cat openssl.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 192.168.100.10
IP.3 = 192.168.100.11
IP.4 = 192.168.100.14
IP.5 = 127.0.0.1
EOF
vagrant@controlplane01:~/certificates/kube-api-server$ openssl genrsa -out kube-apiserver.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
............................++++
................................................................................................++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/kube-api-server$ openssl req -new -key kube-apiserver.key -subj "/CN=kube-apiserver" -out kube-apiserver.csr -config openssl.cnf 
vagrant@controlplane01:~/certificates/kube-api-server$ openssl x509 -req -in kube-apiserver.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out kube-apiserver.crt -extensions v3_req -extfile openssl.cnf -days 1000
Signature ok
subject=CN = kube-apiserver
Getting CA Private Key
```

# etcd server
```console
vagrant@controlplane01:~/certificates/etcd-server$ cat openssl-etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 192.168.100.10
IP.2 = 192.168.100.11
IP.3 = 127.0.0.1
EOF
vagrant@controlplane01:~/certificates/etcd-server$ openssl genrsa -out etcd-server.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
..............................................................................................++++
............................................................................................................................................................................................................++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/etcd-server$ openssl req -new -key etcd-server.key -subj "/CN=etcd-server" -out etcd-server.csr -config openssl-etcd.cnf 
vagrant@controlplane01:~/certificates/etcd-server$ openssl x509 -req -in etcd-server.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out etcd-server.crt -extensions v3_req -extfile openssl-etcd.cnf -days 1000
Signature ok
subject=CN = etcd-server
Getting CA Private Key
```

# service account
```console
vagrant@controlplane01:~/certificates/service-account$ openssl genrsa -out service-account.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
....................................++++
...................................................................................................................................................................++++
e is 65537 (0x010001)
vagrant@controlplane01:~/certificates/service-account$ openssl req -new -key service-account.key -subj "/CN=service-accounts" -out service-account.csr
vagrant@controlplane01:~/certificates/service-account$ openssl x509 -req -in service-account.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out service-acoount.crt -days 1000
Signature ok
subject=CN = service-accounts
Getting CA Private Key
```

# copy certs to controller 02
```console
vagrant@controlplane01:~/certificates$ scp ca/ca.crt ca/ca.key kube-api-server/kube-apiserver.crt kube-api-server/kube-apiserver.key service-account/service-account.key service-account/service-account.crt etcd-server/etcd-server.key etcd-server/etcd-server.crt controlplane02:~/
ca.crt                                                                                                                                                                                                      100% 1696     1.1MB/s   00:00    
ca.key                                                                                                                                                                                                      100% 3243     2.0MB/s   00:00    
kube-apiserver.crt                                                                                                                                                                                          100% 1927     1.4MB/s   00:00    
kube-apiserver.key                                                                                                                                                                                          100% 3243     2.2MB/s   00:00    
service-account.key                                                                                                                                                                                         100% 3243   712.4KB/s   00:00    
service-account.crt                                                                                                                                                                                         100% 1700     1.4MB/s   00:00    
etcd-server.key                                                                                                                                                                                             100% 3243     1.4MB/s   00:00    
etcd-server.crt
```

# kube-proxy configuration file
```console
vagrant@controlplane01:~/certificates$ export LOADBALANCER_ADDRESS=192.168.100.14
vagrant@controlplane01:~/certificates$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca/ca.crt \
    --embed-certs=true \
    --server=https://${LOADBALANCER_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy-client/kube-proxy.crt \
    --client-key=kube-proxy-client/kube-proxy.key \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}
Cluster "kubernetes-the-hard-way" set.
User "system:kube-proxy" set.
Context "default" created.
Switched to context "default".
```


#  kube-controller-manager configuration file
```console
vagrant@controlplane01:~/certificates$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=controller-manager-client/kube-controller-manager.crt \
    --client-key=controller-manager-client/kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}
Cluster "kubernetes-the-hard-way" set.
User "system:kube-controller-manager" set.
Context "default" created.
Switched to context "default".
```

# kube-scheduler configuration file
```console
vagrant@controlplane01:~/certificates$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler-client/kube-scheduler.crt \
    --client-key=kube-scheduler-client/kube-scheduler.key \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}
Cluster "kubernetes-the-hard-way" set.
User "system:kube-scheduler" set.
Context "default" created.
Switched to context "default".
```


# admin configuration file
```console
vagrant@controlplane01:~/certificates$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin-client/admin.crt \
    --client-key=admin-client/admin.key \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
}
Cluster "kubernetes-the-hard-way" set.
User "admin" set.
Context "default" created.
Switched to context "default".
```

# copy files to workers and controller02
```console
vagrant@controlplane01:~/certificates$ scp kube-proxy.kubeconfig node01:~/
kube-proxy.kubeconfig                                                                                                                                                                                       100% 9246     6.4MB/s   00:00    
vagrant@controlplane01:~/certificates$ scp kube-proxy.kubeconfig node02:~/
kube-proxy.kubeconfig                                                                                                                                                                                       100% 9246     5.3MB/s   00:00    
vagrant@controlplane01:~/certificates$ scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig  controlplane02:~/
admin.kubeconfig                                                                                                                                                                                            100% 9245     2.4MB/s   00:00    
kube-controller-manager.kubeconfig                                                                                                                                                                          100% 9303     2.2MB/s   00:00    
kube-scheduler.kubeconfig
```

# encryption key
```console
vagrant@controlplane01:~/certificates$ export ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
vagrant@controlplane01:~/certificates$ cat encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EO
vagrant@controlplane01:~/certificates$ scp encryption-config.yaml controlplane02:~/
encryption-config.yaml
```


# bootstrapping etcd cluster

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/etcd-server.crt \\
  --key-file=/etc/etcd/etcd-server.key \\
  --peer-cert-file=/etc/etcd/etcd-server.crt \\
  --peer-key-file=/etc/etcd/etcd-server.key \\
  --trusted-ca-file=/etc/etcd/ca.crt \\
  --peer-trusted-ca-file=/etc/etcd/ca.crt \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster controlplane01=https://192.168.100.10:2380,controlplane02=https://192.168.100.11:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


# Bootstrapping the Kubernetes Control Plane

```console
vagrant@controlplane02:~$ sudo mkdir -p /etc/kubernetes/config
vagrant@controlplane02:~$ curl -LO https://dl.k8s.io/v1.19.0/kubernetes-server-linux-amd64.tar.gz
vagrant@controlplane02:~$ tar xvf kubernetes-server-linux-amd64.tar.gz
vagrant@controlplane02:~$ cd kubernetes/server/bin/
apiextensions-apiserver  kube-apiserver             kube-apiserver.tar       kube-controller-manager.docker_tag  kube-proxy             kube-proxy.tar  kube-scheduler.docker_tag  kubeadm  kubelet
kube-aggregator          kube-apiserver.docker_tag  kube-controller-manager  kube-controller-manager.tar         kube-proxy.docker_tag  kube-scheduler  kube-scheduler.tar         kubectl  mounter
vagrant@controlplane02:~/kubernetes/server/bin$ sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/
vagrant@controlplane02:~$ kubectl version --client --short
Client Version: v1.19.0
```

## Configure the Kubernetes API Server



```console
vagrant@controlplane02:~$ sudo mkdir -p /var/lib/kubernetes/
vagrant@controlplane02:~$ sudo cp ca.crt ca.key kube-apiserver.crt kube-apiserver.key \
    service-account.key service-account.crt \
    etcd-server.key etcd-server.crt \
    encryption-config.yaml /var/lib/kubernetes/

vagrant@controlplane02:~$ cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=/var/lib/kubernetes/ca.crt \\
  --enable-admission-plugins=NodeRestriction,ServiceAccount \\
  --enable-swagger-ui=true \\
  --enable-bootstrap-token-auth=true \\
  --etcd-cafile=/var/lib/kubernetes/ca.crt \\
  --etcd-certfile=/var/lib/kubernetes/etcd-server.crt \\
  --etcd-keyfile=/var/lib/kubernetes/etcd-server.key \\
  --etcd-servers=https://192.168.100.10:2379,https://192.168.100.11:2379 \\
  --event-ttl=1h \\
  --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.crt \\
  --kubelet-client-certificate=/var/lib/kubernetes/kube-apiserver.crt \\
  --kubelet-client-key=/var/lib/kubernetes/kube-apiserver.key \\
  --kubelet-https=true \\
  --runtime-config=api/all=true \\
  --service-account-key-file=/var/lib/kubernetes/service-account.crt \\
  --service-cluster-ip-range=10.96.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --tls-cert-file=/var/lib/kubernetes/kube-apiserver.crt \\
  --tls-private-key-file=/var/lib/kubernetes/kube-apiserver.key \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

```

## Configure the Kubernetes Controller Manager

```console
vagrant@controlplane02:~$ sudo cp kube-controller-manager.kubeconfig /var/lib/kubernetes/

vagrant@controlplane01:~/certificates$ cat <<EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-controller-manager \\
  --address=0.0.0.0 \\
  --cluster-cidr=192.168.100.0/24 \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/var/lib/kubernetes/ca.crt \\
  --cluster-signing-key-file=/var/lib/kubernetes/ca.key \\
  --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --root-ca-file=/var/lib/kubernetes/ca.crt \\
  --service-account-private-key-file=/var/lib/kubernetes/service-account.key \\
  --service-cluster-ip-range=10.96.0.0/24 \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```


## Configure the Kubernetes Scheduler
```console
vagrant@controlplane02:~$ sudo cp kube-scheduler.kubeconfig /var/lib/kubernetes/

vagrant@controlplane02:~$ cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --kubeconfig=/var/lib/kubernetes/kube-scheduler.kubeconfig \\
  --address=127.0.0.1 \\
  --leader-elect=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

## Start the Controller Services

```console
vagrant@controlplane02:~$ sudo systemctl daemon-reload
vagrant@controlplane02:~$ sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
Created symlink /etc/systemd/system/multi-user.target.wants/kube-apiserver.service → /etc/systemd/system/kube-apiserver.service.
Created symlink /etc/systemd/system/multi-user.target.wants/kube-controller-manager.service → /etc/systemd/system/kube-controller-manager.service.
Created symlink /etc/systemd/system/multi-user.target.wants/kube-scheduler.service → /etc/systemd/system/kube-scheduler.service.
vagrant@controlplane02:~$ sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler
```

## The Kubernetes Frontend Load Balancer

```console
vagrant@loadbalancer:~$  sudo apt-get update && sudo apt-get install -y haproxy
vagrant@loadbalancer:~$ cat <<EOF | sudo tee /etc/haproxy/haproxy.cfg 
frontend kubernetes
    bind 192.168.100.14:6443
    option tcplog
    mode tcp
    default_backend kubernetes-controlplane-nodes

backend kubernetes-controlplane-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server controlplane01 192.168.100.10:6443 check fall 3 rise 2
    server controlplane02 192.168.100.11:6443 check fall 3 rise 2
EOF
```

# Bootstrapping the Kubernetes Worker Nodes

## Provisioning Kubelet Client Certificates

```console
vagrant@controlplane01:~$ cat openssl-node01.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = node01
IP.1 = 192.168.100.12
EOF
vagrant@controlplane01:~$ openssl genrsa -out node01.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
......................................................++++
.........................++++
e is 65537 (0x010001)
vagrant@controlplane01:~$ openssl req -new -key node01.key -subj "/CN=system:node:node01/O=system:nodes" -out node01.csr -config openssl-node01.cnf 
vagrant@controlplane01:~$ openssl x509 -req -in node01.csr -CA certificates/ca/ca.crt -CAkey certificates/ca/ca.key -CAcreateserial -out node01.crt -extensions v3_req -extfile openssl-node01.cnf -days 1000
Signature ok
subject=CN = system:node:node01, O = system:nodes
Getting CA Private Key
```

## The kubelet Kubernetes Configuration File
```console
vagrant@controlplane01:~$ LOADBALANCER_ADDRESS=192.168.100.14
vagrant@controlplane01:~$ echo $LOADBALANCER_ADDRESS
192.168.100.14
vagrant@controlplane01:~$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=certificates/ca/ca.crt \
    --embed-certs=true \
    --server=https://${LOADBALANCER_ADDRESS}:6443 \
    --kubeconfig=node01.kubeconfig

  kubectl config set-credentials system:node:node01 \
    --client-certificate=node01.crt \
    --client-key=node01.key \
    --embed-certs=true \
    --kubeconfig=node01.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:node01 \
    --kubeconfig=node01.kubeconfig

  kubectl config use-context default --kubeconfig=node01.kubeconfig
}
Cluster "kubernetes-the-hard-way" set.
User "system:node:node01" set.
Context "default" created.
Switched to context "default".        
vagrant@controlplane01:~$ scp certificates/ca/ca.crt  node01.kubeconfig node01.key node01.crt node01:~/
ca.crt                                                                                                                                                                                                      100% 1696   281.4KB/s   00:00    
node01.kubeconfig                                                                                                                                                                                           100% 9400     4.7MB/s   00:00    
node01.key                                                                                                                                                                                                  100% 3243     2.5MB/s   00:00    
node01.crt                                                                                                                                                                                                  100% 1814   358.1KB/s   00:00 
```
## download binaries in node01

```console
vagrant@node01:~$ curl -LO https://dl.k8s.io/v1.19.0/kubernetes-node-linux-amd64.tar.gz
vagrant@node01:~$ tar xvf kubernetes-node-linux-amd64.tar.gz
vagrant@node01:~/kubernetes/node/bin$ sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes
vagrant@node01:~$ cd kubernetes/node/bin/
vagrant@node01:~/kubernetes/node/bin$ sudo mv kubelet kubectl kube-proxy /usr/local/bin/
vagrant@node01:~$ sudo mv ${HOSTNAME}.key ${HOSTNAME}.crt /var/lib/kubelet/
vagrant@node01:~$ sudo mv ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
vagrant@node01:~$ sudo mv ca.crt /var/lib/kubernetes/
vagrant@node01:~$ cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.crt"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.96.0.10"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
EOF
vagrant@node01:~$ cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --tls-cert-file=/var/lib/kubelet/${HOSTNAME}.crt \\
  --tls-private-key-file=/var/lib/kubelet/${HOSTNAME}.key \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

vagrant@node01:~$ sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig

vagrant@node01:~$ cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "192.168.100.0/24"
EOF
vagrant@node01:~$ cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

vagrant@controlplane01:~$ kubectl get nodes --kubeconfig certificates/admin.kubeconfig
NAME     STATUS     ROLES    AGE     VERSION
node01   NotReady   <none  3m22s   v1.19.0
```

### node02

```console
vagrant@node02:~$ curl -LO https://dl.k8s.io/v1.19.0/kubernetes-node-linux-amd64.tar.gz
vagrant@node02:~$ tar xvf kubernetes-node-linux-amd64.tar.gz
vagrant@node02:~$ sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes
vagrant@node02:~$ cd kubernetes/node/bin/
vagrant@node02:~/kubernetes/node/bin$ sudo mv kubelet kubectl kube-proxy /usr/local/bin/
vagrant@node02:~$ sudo mv ca.crt /var/lib/kubernetes/
```

### Step 1 Create the Boostrap Token to be used by Nodes(Kubelets) to invoke Certificate API

```console
vagrant@controlplane01:~$  cat bootstrap-token-07401b.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  # Name MUST be of form "bootstrap-token-<token id>"
  name: bootstrap-token-07401b
  namespace: kube-system

# Type MUST be 'bootstrap.kubernetes.io/token'
type: bootstrap.kubernetes.io/token
stringData:
  # Human readable description. Optional.
  description: "The default bootstrap token generated by 'kubeadm init'."

  # Token ID and secret. Required.
  token-id: 07401b
  token-secret: f395accd246ae52d

  # Expiration. Optional.
  expiration: 2021-03-10T03:22:11Z

  # Allowed usages.
  usage-bootstrap-authentication: "true"
  usage-bootstrap-signing: "true"

  # Extra groups to authenticate the token as. Must start with "system:bootstrappers:"
  auth-extra-groups: system:bootstrappers:worker
EOF
vagrant@controlplane01:~$ kubectl create -f bootstrap-token-07401b.yaml
secret/bootstrap-token-07401b created
vagrant@controlplane01:~$ kubectl create clusterrolebinding create-csrs-for-bootstrapping --clusterrole=system:node-bootstrapper --group=system:bootstrappers
clusterrolebinding.rbac.authorization.k8s.io/create-csrs-for-bootstrapping created
vagrant@controlplane01:~$ kubectl create clusterrolebinding auto-approve-csrs-for-group --clusterrole=system:certificates.k8s.io:certificatesigningrequests:nodeclient --group=system:bootstrappers
clusterrolebinding.rbac.authorization.k8s.io/auto-approve-csrs-for-group created
vagrant@controlplane01:~$ kubectl create clusterrolebinding auto-approve-renewals-for-nodes --clusterrole=system:certificates.k8s.io:certificatesigningrequests:selfnodeclient --group=system:nodes
clusterrolebinding.rbac.authorization.k8s.io/auto-approve-renewals-for-nodes created

vagrant@node02:~$ sudo kubectl config --kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig set-cluster bootstrap --server='https://192.168.100.14:6443' --certificate-authority=/var/lib/kubernetes/ca.crt
vagrant@node02:~$ sudo kubectl config --kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig set-credentials kubelet-bootstrap --token=07401b.f395accd246ae52d
vagrant@node02:~$ sudo kubectl config --kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig set-context bootstrap --user=kubelet-bootstrap --cluster=bootstrap
vagrant@node02:~$ sudo kubectl config --kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig use-context bootstrap


vagrant@node02:~$ cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.crt"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.96.0.10"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
EOF

vagrant@node02:~$  cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --bootstrap-kubeconfig="/var/lib/kubelet/bootstrap-kubeconfig" \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --cert-dir=/var/lib/kubelet/pki/ \\
  --rotate-certificates=true \\
  --rotate-server-certificates=true \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

vagrant@node02:~$ sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
vagrant@node02:~$ cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "192.168.100.0/24"
EOF


vagrant@node02:~$ cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

vagrant@node02:~$ sudo systemctl daemon-reload
vagrant@node02:~$ sudo systemctl enable kubelet kube-proxy
vagrant@node02:~$ sudo systemctl start kubelet kube-proxy

vagrant@controlplane01:~$ kubectl get csr
NAME        AGE   SIGNERNAME                                    REQUESTOR                 CONDITION
csr-bszfb   54s   kubernetes.io/kubelet-serving                 system:node:node02        Pending
csr-pnxmp   64s   kubernetes.io/kube-apiserver-client-kubelet   system:bootstrap:07401b   Approved,Issued

vagrant@controlplane01:~$ kubectl certificate approve csr-bszfb
certificatesigningrequest.certificates.k8s.io/csr-bszfb approved
vagrant@controlplane01:~$ kubectl get csr
NAME        AGE    SIGNERNAME                                    REQUESTOR                 CONDITION
csr-bszfb   91s    kubernetes.io/kubelet-serving                 system:node:node02        Approved,Issued
csr-pnxmp   101s   kubernetes.io/kube-apiserver-client-kubelet   system:bootstrap:07401b   Approved,Issued
```

## configure kubeclt
```console
vagrant@controlplane01:~$ {
  KUBERNETES_LB_ADDRESS=192.168.100.14

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=certificates/ca/ca.crt \
    --embed-certs=true \
    --server=https://${KUBERNETES_LB_ADDRESS}:6443

  kubectl config set-credentials admin \
    --client-certificate=certificates/admin-client/admin.crt \
    --client-key=certificates/admin-client/admin.key

  kubectl config set-context kubernetes-the-hard-way \
    --cluster=kubernetes-the-hard-way \
    --user=admin

  kubectl config use-context kubernetes-the-hard-way
}
Cluster "kubernetes-the-hard-way" set.
User "admin" set.
Context "kubernetes-the-hard-way" modified.
Switched to context "kubernetes-the-hard-way".
vagrant@controlplane01:~$ 
vagrant@controlplane01:~$ kubectl get cs
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok                  
scheduler            Healthy   ok                  
etcd-1               Healthy   {"health":"true"}   
etcd-0               Healthy   {"health":"true"}   
vagrant@controlplane01:~$ kubectl get node
NAME     STATUS     ROLES    AGE     VERSION
node01   NotReady   <none  24m     v1.19.0
node02   NotReady   <none  3m38s   v1.19.0
```

## deploy pod networking

```console
vagrant@node01:~$ curl -LO https://github.com/containernetworking/plugins/releases/download/v0.8.7/cni-plugins-linux-amd64-v0.8.7.tgz
vagrant@node02:~$ curl -LO https://github.com/containernetworking/plugins/releases/download/v0.8.7/cni-plugins-linux-amd64-v0.8.7.tgz

vagrant@node01:~$ sudo tar xvf cni-plugins-linux-amd64-v0.8.7.tgz --directory /opt/cni/bin/
vagrant@node02:~$ sudo tar xvf cni-plugins-linux-amd64-v0.8.7.tgz --directory /opt/cni/bin/

vagrant@controlplane01:~$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.apps/weave-net created
vagrant@controlplane01:~$ kubectl -n kube-system get pod
NAME              READY   STATUS    RESTARTS   AGE
weave-net-9k2hw   2/2     Running   0          118s
weave-net-v8x9b   2/2     Running   0          118s
```
## RBAC for Kubelet Authorization

```console
vagrant@controlplane01:~/certificates$ cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
> apiVersion: rbac.authorization.k8s.io/v1beta1
> kind: ClusterRole
> metadata:
>   annotations:
>     rbac.authorization.kubernetes.io/autoupdate: "true"
>   labels:
>     kubernetes.io/bootstrapping: rbac-defaults
>   name: system:kube-apiserver-to-kubelet
> rules:
>   - apiGroups:
>       - ""
>     resources:
>       - nodes/proxy
>       - nodes/stats
>       - nodes/log
>       - nodes/spec
>       - nodes/metrics
>     verbs:
>       - "*"
> EOF
Warning: rbac.authorization.k8s.io/v1beta1 ClusterRole is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRole
clusterrole.rbac.authorization.k8s.io/system:kube-apiserver-to-kubelet created
vagrant@controlplane01:~/certificates$ cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
> apiVersion: rbac.authorization.k8s.io/v1beta1
> kind: ClusterRoleBinding
> metadata:
>   name: system:kube-apiserver
>   namespace: ""
> roleRef:
>   apiGroup: rbac.authorization.k8s.io
>   kind: ClusterRole
>   name: system:kube-apiserver-to-kubelet
> subjects:
>   - apiGroup: rbac.authorization.k8s.io
>     kind: User
>     name: kube-apiserver
> EOF
Warning: rbac.authorization.k8s.io/v1beta1 ClusterRoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRoleBinding
clusterrolebinding.rbac.authorization.k8s.io/system:kube-apiserver created
```
### Deploying the DNS Cluster Add-on
```console
vagrant@controlplane01:~$ curl -LO https://raw.githubusercontent.com/mmumshad/kubernetes-the-hard-way/master/deployments/coredns.yaml
vagrant@controlplane01:~$ sed -i 's/extensions\/v1beta1/apps\/v1/g' coredns.yaml
vagrant@controlplane01:~$ sed -i 's/rbac.authorization.k8s.io\/v1beta1/rbac.authorization.k8s.io\/v1/g' coredns.yaml
vagrant@controlplane01:~$ kubectl apply -f coredns.yaml 
serviceaccount/coredns created
clusterrole.rbac.authorization.k8s.io/system:coredns created
clusterrolebinding.rbac.authorization.k8s.io/system:coredns created
configmap/coredns created
deployment.apps/coredns created
service/kube-dns created
vagrant@controlplane01:~$ kubectl get pods -l k8s-app=kube-dns -n kube-system
NAME                       READY   STATUS    RESTARTS   AGE
coredns-78cb77577b-nv7x2   1/1     Running   0          6s
coredns-78cb77577b-zxpr5   1/1     Running   0          6s

vagrant@controlplane01:~$ kubectl run --generator=run-pod/v1  busybox --image=busybox:1.28 --command -- sleep 3600
pod/busybox created
vagrant@controlplane01:~$ kubectl get pods -l run=busybox
NAME      READY   STATUS    RESTARTS   AGE
busybox   1/1     Running   0          16s
vagrant@controlplane01:~$ kubectl exec -ti busybox -- nslookup kubernetes
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes
Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local
```
