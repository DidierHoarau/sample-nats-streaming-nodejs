#/bin/bash

https://nats.io/documentation/additional_documentation/nats-streaming-swarm/

docker network rm nats-streaming-example

docker network create --driver overlay --attachable nats-streaming-example

for i in `seq 1 3`; do
    docker service create --network nats-streaming-example \
                             --name nats-cluster-node-$i nats:1.1.0 \
                             -cluster nats://0.0.0.0:6222 \
                             -routes nats://nats-cluster-node-1:6222,nats://nats-cluster-node-2:6222,nats://nats-cluster-node-3:6222
done

for i in `seq 1 3`; do
    docker service create --network nats-streaming-example \
                             --name nats-streaming-node-$i nats-streaming:0.9.2 \
                             -store file -dir store -clustered -cluster_id swarm -cluster_node_id node-$i \
                             -cluster_peers node-1,node-2,node-3 \
                             -nats_server nats://nats-cluster-node-1:4222,nats://nats-cluster-node-2:4222,nats://nats-cluster-node-3:4222
done

    docker run --network nats-streaming-example -it golang:latest