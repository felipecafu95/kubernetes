#!/bin/bash

# generate ssh keys to access worker nodes
ssh-keygen -q -N '' -t rsa -b 2048 -C vagrant-nodes -f ~/.ssh/id_rsa
cp ~/.ssh/id_rsa* /home/vagrant/.ssh/
chown -R vagrant:vagrant /home/vagrant

# add public key to ~/.ssh/authorized_keys in all nodes
echo -e "vagrant@controlplane01:~$ cat .ssh/id_rsa.pub\n
---\n
vagrant@controlplane02:~$ vim .ssh/authorized_keys\n
---\n
vagrant@node01:~$ vim .ssh/authorized_keys\n
---\n
vagrant@node02:~$ vim .ssh/authorized_keys\n
---\n
vagrant@lb:~$ vim .ssh/authorized_keys"