#/bin/bash

set -e

mkdir -p ./volumes/node-1
mkdir -p ./volumes/node-2
mkdir -p ./volumes/node-3

if [ "$(docker network ls | grep nats-network | wc -l)" == "0" ]; then
    docker network create --driver overlay --attachable nats-network
fi

npm install

docker-compose up
