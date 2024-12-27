#!/bin/bash

# Config maken voor de MongoDB deployment
# mongo-storage voor persistent data
kubectl apply -f mongo-storage.yaml
kubectl apply -f mongo-deployment.yaml

# Config maken voor het nginx config bestand
kubectl apply -f nginxconfig-configmap.yaml

# Config maken met de website bestanden. Daarna ze applyen
kubectl create configmap reminder-app-frontend --from-file=../docker/reminder-app/public -o yaml --dry-run=client > website-configmap.yaml
kubectl apply -f website-configmap.yaml

# NodeJS API, dan Webserver
kubectl apply -f app-deployment.yaml
kubectl apply -f nginx-deployment.yaml
