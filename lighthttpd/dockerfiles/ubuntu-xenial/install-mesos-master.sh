#!/bin/bash
# https://www.digitalocean.com/community/tutorials/how-to-configure-a-production-ready-mesosphere-cluster-on-ubuntu-14-04

apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list
DEBIAN_FRONTEND=noninteractive apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get install -y zookeeper mesos marathon chronos


# Set up the Zookeeper Connection Info for Mesos

serverhostname1=node1
serverhostname2=node2
serverhostname3=node3

serverip1=10.6.1.101
serverip2=10.6.1.102
serverip3=10.6.1.103

quorum=2

cat > /etc/mesos/zk <<EOF
zk://$serverip1:2181,$serverip2:2181,$serverip3:2181/mesos
EOF



# Configure the Master Server's Zookeeper Configuration
case $(hostname) in
  $serverhostname1)
    serverid=1
    serverip=$serverip1
  ;;
  $serverhostname2) 
    serverid=2
    serverip=$serverip2
  ;;
  $serverhostname3)
    serverid=3
    serverip=$serverip3
  ;;
  *) 
    echo NODE HOSTNAME FOR MASTER SERVER MISMATCH FIX CONFIGURATION
    exit 3
  ;;
esac

cat > /etc/zookeeper/conf/myid <<EOF
$serverid
EOF


cat > /etc/zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/var/lib/zookeeper
clientPort=2181
server.1=10.6.1.101:2888:3888
server.2=10.6.1.102:2888:3888
server.3=10.6.1.103:2888:3888
EOF

cat > /etc/mesos-master/quorum <<EOF
$quorum
EOF

cat > /etc/mesos-master/ip  <<EOF
$serverip
EOF

cat > /etc/mesos-master/hostname <<EOF
$serverip
EOF

# Configure Marathon on the Master Servers
mkdir -p /etc/marathon/conf

cat > /etc/marathon/conf/hostname <<EOF
$serverip
EOF

cat > /etc/marathon/conf/master <<EOF
zk://$serverip1:2181,$serverip2:2181,$serverip3:2181/mesos
EOF

cat > /etc/marathon/conf/zk <<EOF
zk://$serverip1:2181,$serverip2:2181,$serverip3:2181/marathon
EOF

cat > /etc/mesos-slave/ip <<EOF
$serverip
EOF

cat > /etc/mesos-slave/hostname <<EOF
$serverip
EOF

systemctl enable mesos-master
systemctl enable mesos-slave
systemctl enable zookeeper
systemctl enable marathon


