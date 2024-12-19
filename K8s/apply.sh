#!/bin/bash
minikube kubectl -- apply -f mongo-deployment.yaml

minikube kubectl -- apply -f nginxconfig-configmap.yaml

minikube kubectl -- create configmap reminder-app-frontend --from-file=../docker/reminder-app/public -o yaml --dry-run=client > website-configmap.yaml
minikube kubectl -- apply -f website-configmap.yaml

minikube kubectl -- apply -f nginx-deployment.yaml
minikube kubectl -- apply -f app-deployment.yaml
