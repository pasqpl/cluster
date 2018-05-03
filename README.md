--------------------------------------------
## Mesos cluster
--------------------------------------------

# Step 5
  Test mesos-dns http api
  Test mesos-dns using dig/hosts/nslookup commands
  Test demo4 via webbrowser/git

# Step 4
  Deploy mesos-dns.json trgough marathon web-interface/web-api

# Step 3
  Deploy demo4.json via marathon web-interface/web-api

# Step 2
  Start docker containers: mesos-agent on computing nodes

# Step 1
  Start docker containers: mesos-master, marathon, zookeeper on management nodes


-------------------------------------------------------
## On other nodes connected to the first node
------------------------------------------------------
Step 2
  Manualy boot from LAN and wait till end of installation

Step 1
  Ensure that the DHCP server from first node is working

--------------------------------------------------------
## On the first node,
--------------------------------------------------------

# Step 6
  Push mesos-master, mesos-agent, zookeeper, marathon, mesos-dns, demo4 into private repository

# Step 5
  Build docker images: mesos-master, mesos-agent, marathon, mesos-dns, demo4  

# Step 4
  Start docker containers: isc-dhcp, registry, lighthttpd, tftpd, (optionaly apt-cacher-ng)

# Step 3
  Configure DHCP server 
     This configuration asume that:
     * eth0 is connected to internet
     * eth1 is connected to cluster LAN
     (update mac-address inside the dhcpd.conf)

# Step 2
  Build docker images: isc-dhcp, registry, lighthttpd, tftpd, (optionaly apt-cacher-ng)

# Step 1
  Clone git repo

---------------------------------------------------------
# My mesos demo
---------------------------------------------------------

Those are configured by dhcpd.conf:
node1;10.6.1.101
node2;10.6.1.102
node3;10.6.1.103
node4;10.6.1.104
node5;10.6.1.105
node6;10.6.1.106

