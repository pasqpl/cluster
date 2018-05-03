#!/bin/bash



function run_zk(){
  # https://github.com/sekka1/mesosphere-docker#multi-node-setup
  HOST_IP_1=10.6.1.101
  HOST_IP_2=10.6.1.103
  HOST_IP_3=10.6.1.105


  docker run -d --restart=always --net=host \
     -e ADDITIONAL_ZOOKEEPER_1="server.1=${HOST_IP_1}:2888:3888" \
     -e ADDITIONAL_ZOOKEEPER_2="server.2=${HOST_IP_2}:2888:3888" \
     -e ADDITIONAL_ZOOKEEPER_3="server.3=${HOST_IP_3}:2888:3888"  \
     -e SERVER_ID=${NODE_ID} \
     --name zookeeper private.registry.local:443/cluster/zookeeper
}



function run_master(){


docker run -d --restart=always --net=host \
  -e MESOS_PORT=5050 \
  -e MESOS_ZK=zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/mesos \
  -e MESOS_IP=${SERVERIP}  \
  -e MESOS_QUORUM=2 \
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
  -e MESOS_SWITCH_USER=0 \
  -e MESOS_HOSTNAME=$(hostname) \
  -e MESOS_IP=${SERVERIP}  \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /cgroup:/cgroup \
  -v /sys:/sys \
  --name slave \
  --entrypoint mesos-slave \
  private.registry.local:443/mesosphere/mesos:1.5.0 \
  --no-systemd_enable_support --master=zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/mesos --work_dir=/var/tmp/mesos
}

function run_marathon(){

docker run -d \
           --restart=always \
           --net=host \
           --privileged \
           --name marathon \
           --entrypoint marathon \
           private.registry.local:443/cluster/marathon \
           --master=zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/mesos --zk zk://10.6.1.101:2181,10.6.1.103:2181,10.6.1.105:2181/marathon
}

function pull_demo_image(){
  docker pull private.registry.local:443/cluster/hello-node
}

docker stop zookeeper master slave marathon
docker rm zookeeper master slave marathon


case $(hostname) in
  "node1")
    SERVERIP=10.6.1.101
    NODE_ID=1
    run_zk
    run_master
    run_marathon
  ;;
  "node3")
    SERVERIP=10.6.1.103
    NODE_ID=2
    run_zk
    run_master
    run_marathon
  ;;
  "node5")
    SERVERIP=10.6.1.105
    NODE_ID=3
    run_zk
    run_master
    run_marathon
  ;;
  "node2")
    SERVERIP=10.6.1.102
    run_slave
    pull_demo_image
  ;;
  "node4")
    SERVERIP=10.6.1.104
    run_slave
    pull_demo_image
  ;;
  "node6")
    SERVERIP=10.6.1.106
    run_slave
    pull_demo_image
  ;;

esac
