#!/bin/bash
unset http_proxy
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -yq docker.io
sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
