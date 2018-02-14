FROM ubuntu
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y openntpd
RUN DEBIAN_FRONTEND=noninteractive apt-get clean autoclean && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
ADD ./dockerfiles/run /opt/run
ADD ./dockerfiles/ntp.conf /etc/ntp.conf
RUN chmod +x /opt/run
ENTRYPOINT ["/opt/run"]
