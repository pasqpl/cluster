#!/bin/bash

apt-get update && \
  apt-get -y install apt-transport-https ca-certificates && \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
  echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get -y install docker-engine

# Adding unsecure registry.

mkdir -p /etc/docker/

cat > /etc/docker/daemon.json <<EOaF
{
  "insecure-registries" : ["private.registry.local:443"]
}
EOaF

/etc/init.d/docker restart

cat > /etc/hosts <<EOF
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

10.6.1.101 node1
10.6.1.102 node2
10.6.1.103 node3
10.6.1.104 node4
10.6.1.105 node5
10.6.1.1 private.registry.local
EOF
