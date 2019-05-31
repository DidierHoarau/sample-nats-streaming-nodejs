#!/bin/bash

kubectl delete $(kubectl get all --no-headers | grep nats-demo-app | grep deployment | cut -f1 -d" ") || true
kubectl delete $(kubectl get all --no-headers | grep nats-demo-app | grep service | cut -f1 -d" ") || true

sleep 5

../../../start-service.sh .

sleep 15

kubectl logs -f $(kubectl get all --no-headers | grep nats-demo-app | grep pod | cut -f1 -d" ")