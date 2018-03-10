!/bin/bash

apt-get update && \
  apt-get -y install apt-transport-https ca-certificates && \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
  echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get -y install curl docker-engine















sed -i 's/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
# Adding unsecure registry.
cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["private.registry.local:443"]
}
EOF

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


















function run_zk(){
  # https://github.com/sekka1/mesosphere-docker#multi-node-setup
  HOST_IP_1=10.6.1.101
  HOST_IP_2=10.6.1.103
  HOST_IP_3=10.6.1.105
  NODE_ID=$(hostname | sed s@node@@g)


  docker run -d --restart=always --net=host \
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
  -e MESOS_IP=${SERVERIP}  \
  -e MESOS_QUORUM=3 \
  -e MESOS_HOSTNAME=$(hostname) \
  -e MESOS_REGISTRY=in_memory \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  --name master \
  --entrypoint mesos-master \
  private.registry.local:443/mesosphere/mesos:1.5.0 \
  --registry=in_memory

}

function run_slave(){

docker run -d --restart=always --net=host --privileged \
  -e MESOS_PORT=5051 \
  -e MESOS_MASTER=zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/mesos \
  -e MESOS_SWITCH_USER=0 \
  -e MESOS_HOSTNAME=$(hostname) \
  -e MESOS_IP=${SERVERIP}  \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /cgroup:/cgroup \
  -v /sys:/sys \
  --name slave \
  --entrypoint mesos-slave \
  private.registry.local:443/mesosphere/mesos:1.5.0
}

docker stop zookeeper master slave 
docker rm zookeeper master slave


case $(hostname) in
  "node1")
    SERVERIP=10.6.1.101
    run_zk
    run_master
    run_slave
  ;;
  "node3")
    SERVERIP=10.6.1.103
    run_zk
    run_master
    run_slave
  ;;
  "node5")
    SERVERIP=10.6.1.105
    run_zk
    run_master
    run_slave
  ;;
  "node2")
    SERVERIP=10.6.1.102
    run_slave
  ;;
  "node4")
    SERVERIP=10.6.1.104
    run_slave
  ;;
esac
