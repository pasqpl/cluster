FROM debian:jessie
ENV ARCH amd64
ENV DIST jessie
ENV MIRROR http://ftp.pl.debian.org
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y isc-dhcp-server 
RUN DEBIAN_FRONTEND=noninteractive apt-get clean autoclean && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y 
ADD ./dockerfiles/run /opt/run
ADD ./dockerfiles/dhcpd.conf /data/dhcpd.conf
RUN chmod +x /opt/run
ENTRYPOINT ["/opt/run"]
