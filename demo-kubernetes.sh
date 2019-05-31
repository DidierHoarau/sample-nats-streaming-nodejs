set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}/kubernetes"


# -----------------------------------------------------------------------------
# NATS Streaming Cluster

# https://github.com/nats-io/nats-streaming-operator
kubectl apply -f https://github.com/nats-io/nats-operator/releases/download/v0.5.0/00-prereqs.yaml
kubectl apply -f https://github.com/nats-io/nats-operator/releases/download/v0.5.0/10-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/nats-io/nats-streaming-operator/master/deploy/default-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/nats-io/nats-streaming-operator/master/deploy/deployment.yaml

sleep 20

kubectl get crd

kubectl apply -f kube-deploy.yml


# -----------------------------------------------------------------------------
# Demo App

cd demo-app

kubectl delete $(kubectl get all --no-headers | grep nats-demo-app | grep deployment | cut -f1 -d" ") > /dev/null 2>&1 || true
kubectl delete $(kubectl get all --no-headers | grep nats-demo-app | grep service | cut -f1 -d" ") > /dev/null 2>&1 || true

sleep 5

export SERVICE=nats-demo-app
export SERVICE_VERSION=1.0.0
export DOCKER_REGISTRY=127.0.0.1:5000
export REGISTRY_NAMESPACE=dev
export VOLUMES_BASE_DIR=/opt/data

docker-compose build

cat ./kube-deploy.yml \
    | sed "s/\${SERVICE}/${SERVICE}/g" \
    | sed "s/\${SERVICE_VERSION}/${SERVICE_VERSION}/g" \
    | sed "s/\${DOCKER_REGISTRY}/${DOCKER_REGISTRY}/g" \
    | sed "s/\${REGISTRY_NAMESPACE}/${REGISTRY_NAMESPACE}/g" \
    | sed "s/\${STAGE}/${STAGE}/g" \
    | kubectl apply -f -

sleep 20

kubectl logs -f $(kubectl get all --no-headers | grep nats-demo-app | grep pod | cut -f1 -d" ")