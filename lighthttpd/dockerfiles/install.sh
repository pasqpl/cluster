#!/bin/bash
# https://kubernetes.io/docs/setup/independent/install-kubeadm/
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -yq kubelet kubeadm kubectl
