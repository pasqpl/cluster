#!/bin/bash
unset http_proxy
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -yq docker.io
sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config


# Adding unsecure registry.
cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["private.registry.local:443"]
}
EOF

echo "10.6.1.1 private.registry.local" >> /etc/hosts
