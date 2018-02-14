FROM debian:jessie
ENV ARCH amd64
ENV DIST jessie
ENV new a
ENV MIRROR http://ftp.pl.debian.org
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y lighttpd
RUN DEBIAN_FRONTEND=noninteractive apt-get clean autoclean && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y 
ADD ./dockerfiles/run /opt/run
VOLUME /var/www/html
EXPOSE 80
RUN chmod +x /opt/run
ENTRYPOINT ["/opt/run"]
