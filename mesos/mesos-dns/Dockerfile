FROM mesosphere/mesos-dns
COPY dockerfiles/config.json /config.json
ADD https://github.com/mesosphere/mesos-dns/releases/download/v0.6.0/mesos-dns-v0.6.0-linux-amd64 /mesos-dnsv0.6.0
RUN chmod +x /mesos-dnsv0.6.0
ENTRYPOINT [ "/mesos-dnsv0.6.0", "-config=/config.json" ]
