#https://github.com/nimmis/docker-java/tree/master/openjdk-8-jre-headless


FROM nimmis/java:openjdk-8-jre-headless
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  wget && \
    DEBIAN_FRONTEND=noninteractive apt-get clean autoclean && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-3.4.10 /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

# Only checks if server is up and listening, not quorum.
# See https://zookeeper.apache.org/doc/r3.4.10/zookeeperAdmin.html#sc_zkCommands
HEALTHCHECK CMD [ $(echo ruok | nc 127.0.0.1:2181) == "imok" ] || exit 1


ADD dockerfiles/run /opt/run
RUN chmod 777 /opt/run
EXPOSE 2181 2888 3888 
WORKDIR /opt/zookeeper
VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]
CMD ["/opt/run"]
