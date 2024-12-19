#!/bin/bash

# Config maken voor de MongoDB deployment
# mongo-storage voor persistent data
minikube kubectl -- apply -f mongo-storage.yaml
minikube kubectl -- apply -f mongo-deployment.yaml

# Config maken voor het nginx config bestand
minikube kubectl -- apply -f nginxconfig-configmap.yaml

# Config maken met de website bestanden. Daarna ze applyen
minikube kubectl -- create configmap reminder-app-frontend --from-file=../docker/reminder-app/public -o yaml --dry-run=client > website-configmap.yaml
minikube kubectl -- apply -f website-configmap.yaml

# NodeJS API, dan Webserver
minikube kubectl -- apply -f app-deployment.yaml
minikube kubectl -- apply -f nginx-deployment.yaml
