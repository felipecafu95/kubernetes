#!/bin/bash
cat >> /etc/hosts <<EOF
192.168.100.10  controlplane01    
192.168.100.11  controlplane02
192.168.100.12  node01
192.168.100.13  node02  
192.168.100.14  lb
EOF

sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts