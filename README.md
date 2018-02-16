# cluster

# To start 
YOURDIRECTORYPATH=/opt/pasqpl

mkdir -p $YOURDIRECTORYPATH
cd $YOURDIRECTORYPATH

git clone https://github.com/pasqpl/cluster



# Architecture overview

Components:
  # isc-dhcp-server - for PXE, iPXE
  # tftp - for PXE that will chainload iPXE
  # lighthttpd - as the logic could be implemented here
  # apt-cacher-ng - when you are far away from high speed internet connection
  # openntpd - time sync is important


# tftp  
  iPXE kernel

# lighthttpd
  ipxe configuration how to load ubuntu installer
  ubuntu.cfg - for ubuntu installer to avoid anoing questions during installation
  install.sh - for ubuntu installer instruction how to install additional stuff 
  ubuntu installer kernel
  
# Openntpd 
# apt-cacher-ng 
