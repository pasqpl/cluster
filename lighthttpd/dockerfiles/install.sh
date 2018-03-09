#!/bin/bash
unset http_proxy
export DEBIAN_FRONTEND=noninteractive
sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config


# Adding unsecure registry.
cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["private.registry.local:443"]
}
EOF


cat > /etc/hosts <<EOF
127.0.0.1       localhost
127.0.1.1       $(hostname)

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

10.6.1.101 s1
10.6.1.102 s2
10.6.1.103 s3
10.6.1.104 s4
10.6.1.105 s5
10.6.1.1 private.registry.local

EOF
function run_zk(){
  # https://github.com/sekka1/mesosphere-docker#multi-node-setup
  HOST_IP_1=10.6.1.101
  HOST_IP_2=10.6.1.103
  HOST_IP_3=10.6.1.105
  NODE_ID=$(hostname | sed s@node@@g)


   docker run -d \
     -p 2181:2181 \
     -p 2888:2888 \
     -p 3888:3888 \
     -e ADDITIONAL_ZOOKEEPER_1=ADDITIONAL_ZOOKEEPER_1=server.1=${HOST_IP_1}:2888:3888 \
     -e ADDITIONAL_ZOOKEEPER_2=ADDITIONAL_ZOOKEEPER_1=server.2=${HOST_IP_2}:2888:3888 \
     -e ADDITIONAL_ZOOKEEPER_3=ADDITIONAL_ZOOKEEPER_1=server.3=${HOST_IP_3}:2888:3888  \
     -e SERVER_ID=${NODE_ID} \
     --name zookeeper private.registry.local:443/cluster/zookeeper
}



function run_master(){


docker run -d --restart=always --net=host \
  -e MESOS_PORT=5050 \
  -e MESOS_ZK=zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/mesos \
  -e MESOS_QUORUM=2 \
  -e MESOS_REGISTRY=in_memory \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  private.registry.local:443/mesosphere/mesos-master:0.28.0-2.0.16.ubuntu1404

}

function run_slave(){

docker run -d --restart=always --net=host --privileged \
  -e MESOS_PORT=5051 \
  -e MESOS_MASTER=zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/mesos \
  -e MESOS_SWITCH_USER=0 \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /cgroup:/cgroup \
  -v /sys:/sys \
  -v /usr/local/bin/docker:/usr/local/bin/docker \
  private.registry.local:443/mesosphere/mesos-slave:0.28.0-2.0.16.ubuntu1404

}



case $(hostname) in
  "node1"|"node3"|"node5")
    run_zk
    run_master
    run_slave
  ;;
  *)
    run_zk
    run_slave
  ;;
esac
