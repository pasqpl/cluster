TESTING TESTING TESTING

# Machine provisioning
isc-dhcp - node network config based on macaddress, configuration for PXE, configruation for iPXE
lighthttpd - provide configuration for iPXE, provide configuration for ubuntu preseed instllation
openntp - provide time over network
tftpd - provide configuration for PXE
apt-cacher-ng - to speedup reinstallation of the base system (this will be removed)
registry - local registry, to avoid pulling images from docker-hub (this will be removed)

# Cluster middlevare - testing
mesos - 
kubernetes

# Testing
portainer  - manage docker in webbrowser (it is easy to fully fill asigned disk image with the VOLUMES old IMAGES so visualisation is really needed
hello-node - simple node.js http server that will print "Hello node + container hostname"



STATUS:
  isc-dhcp Ready
    - provide files for pxe boot as expected
    - provide presistant dhcp lease as expected,
    - provide pxe configuration as expected,
    - provide ipxe configruation as expected,
    - provide node hostanmes as expected,

  lighthttpd Static configuration Ready
    - provide static configuration for preseed ubuntu instalation as expected, 
    - privide dynamic configuration for preseed installation NOK (manual configuraton for master/slave nodes still required)
    - provide static configuration for iPXE as expected
    - provide dynamic configuration for iPXE (machine commisioning before installation should be added here)
  
  openntp Ready,
    - sync with remote server Ready,
    - provide time to local servers Ready,

  tftpd Ready,
    - provide files to chainload iPXE via PXE boot as expected,
  
  apt-cacher-ng Ready
    - avoid downloading the same debian/ubuntu packages during node provisioning as expected
  
  registry insecure Ready
    - avoid downloading the same docker/images during tests as expected,
    - create certificate based autorisation, NOK
    - manage docker registry users, NOK

  mesos, inprogress
    - 

  kubernetes based on kubeadm user manual READY
    - used kubeadm to initialize 5node cluster that with one master as expected,
    - used kubectl to deploy hello-node service as expected, 
    - scalle-up hello-node to 20 instances , as expected
    - scalle-down hello-node to 20 instances, as expected
    - HA setup for master node, missing in this version of kubeadm

  

Known problems:
  - VirtualBox and PXE-BOOT - machine must be powered off and powered on - othervise it will not load iPXE configuration




