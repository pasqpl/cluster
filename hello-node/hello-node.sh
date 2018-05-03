#!/bin/bash
docker run -d  -it -p5555:8080 --name hello-node private.registry.local:443/cluster/hello-node
