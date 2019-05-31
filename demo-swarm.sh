#/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}/swarm"

if ! docker network inspect nats-network > /dev/null 2>&1 ; then
    docker network create nats-network --attachable --driver overlay
fi

mkdir -p ./volumes/node-1
mkdir -p ./volumes/node-2
mkdir -p ./volumes/node-3

npm ci

docker-compose -p nats-demo up
