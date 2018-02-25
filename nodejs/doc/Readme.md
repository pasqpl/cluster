# To run container from private docker registry that is upandrunning on 10.6.1.1 
  docker run -d -it -p5555:8080 --name hello-node private.registry.local:443/cluster/hello-node

# To test this simple execute command
  wget localhost:5555
