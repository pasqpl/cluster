FROM ubuntu
VOLUME /var/cache/apt-cacher-ng
RUN apt-get update && apt-get install -y apt-cacher-ng
EXPOSE 3142
ADD dockerfiles/run /opt/run
RUN chmod +x /opt/run
CMD /opt/run
