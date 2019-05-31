#!/bin/bash

# Kubernetes
kubectl delete $(kubectl get all --no-headers | grep nats-demo-app | grep deployment | cut -f1 -d" ") > /dev/null 2>&1 || true
kubectl delete $(kubectl get all --no-headers | grep nats-demo-app | grep service | cut -f1 -d" ") > /dev/null 2>&1 || true
kubectl delete $(kubectl get all --no-headers | grep nats-operator | grep deployment | cut -f1 -d" ") > /dev/null 2>&1 || true
kubectl delete $(kubectl get all --no-headers | grep nats-streaming-operator | grep deployment | cut -f1 -d" ") > /dev/null 2>&1 || true
kubectl delete crd natsclusters.nats.io > /dev/null 2>&1 || true
kubectl delete crd natsserviceroles.nats.io > /dev/null 2>&1 || true
kubectl delete crd natsstreamingclusters.streaming.nats.io > /dev/null 2>&1 || true
