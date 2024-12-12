#!/bin/bash
kubectl apply -f mongo.yaml
kubectl apply -f app.yaml
kubectl apply -f nginx.yaml
