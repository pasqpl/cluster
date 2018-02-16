#!/bin/bash

# https://bugs.launchpad.net/ubuntu/+source/debian-installer/+bug/568704
unset http_proxy


# https://kubernetes.io/docs/setup/independent/install-kubeadm/
wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -yq kubelet kubeadm kubectl docker.io

sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config


