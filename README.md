[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/x34QSMR0)

# Cloud Infrastructure - Reminder App

In deze repository beschrijven we het proces van een simpele Node.js app naar een applicatie die als cluster kan worden gedeployed. Dit evolueert doorheen verschillende software oplossingen. Standaard wordt een WSL2 Ubuntu 24.04 machine gebruikt om alle commando's uit te voeren. 

## Reminder App

De eigenlijke app is gemaakt met HTML, CSS en Javascript. De website maakt gebruik van Bootstrap om een simpele weergave te geven van herinneringen. Die herinneringen kan je met een CRUD-systeem creëren, aanpassen en verwijderen. Die CRUD aanvragen worden gestuurd naar een express.js backend. In deze backend worden de requests behandeld en verwerkt in een MongoDB database.
De webapp bestaat dus uit volgende delen:

-   Frontend (HTML, CSS, JS)
-   Backend (Node.js - Express)
-   Database (MongoDB - Mongoose)

## Docker

Om onze webapp te Dockerizen, moeten we voor de gebruikte services een Dockerfile moeten maken. Services die in Docker Hub al een image hebben kunnen we pullen. Dit wordt samengebracht in een Docker Compose file. Concreet beslis ik voor de Node app een Dockerfile te maken. Voor MongoDB en Nginx (de webserver die we zullen gebruiken om de frontend op te hosten) kunnen we een bestaande image gebruiken.

Voorlopig zijn er in onze docker-compose drie services. Twee daarvan worden rechtstreeks gepulled van Docker Hub. De laatste, onze app zelf, wordt zelf gemaakt via een Dockerfile. Deze zullen we builden in een image.
Volgende commando's worden hiervoor gebruikt. (working directory is `/docker/reminder-app/`)

```console
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t reminder-app .

#Pushen naar Docker Hub
docker build -t thybevb/reminder-app:latest .
docker images -> image id kopieren
docker tag <image-id> thybevb/reminder-app:latest
docker push ThybeVB/reminder-app:latest
```

## Minikube / Kubernetes

Om Minikube te installeren (in mijn geval op WSL2 Ubuntu), moet ook Docker Engine draaien op de machine om als driver te werken bij Minikube. Daarna kunnen we Minikube starten.

```console
minikube start --driver=docker
```

Met een werkende Minikube kunnen we beginnen met onze Kubernetes te maken. Om dat we in het deel over Docker onze image hebben gepushed op Docker Hub, kan ik in Kubernetes een deployment file maken hiervoor. Dit kan ook voor onze andere nodige services; mongo en nginx. Dit is een overzicht van de gemaakte bestanden:

- app-deployment.yaml
- mongo-deployment.yaml
  - mongo-storage.yaml
- website-configmap.yaml
- nginx-deployment.yaml
  - nginxconfig-configmap.yaml

Elk deployment bestand bevat een Deployment en een Service onderdeel. Dit kan ook opgesplist worden met een services bestand, maar ik vond dit overzichtelijker om het in hetzelfde bestand te zetten. Merk ook op dat er config bestanden zijn. Deze zijn ondersteundende configbestanden voor de deployments. We kunnen al de scripten applyen via het `apply.sh` bestand.

```bash
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
```
Merk op dat de volgorde hier belangrijk is. mongo-deployment kan bijvoorbeeld niet werken als het ondersteundende storage bestand nog niet werd geapplyed.

Wanneer we het apply script uitvoeren worden onze pods en services gemaakt. Enkel nginx wordt exposed op onze localhost. De andere services kunnen enkel aan elkaar. 

Om de LoadBalancer nginx een External IP te geven, kunnen we `minikube tunnel` uitvoeren om een tunnel aan te maken van de kubernetes node naar onze host.

Een kort overzicht van de runnende pods en services:
![Pods](./md-images/pods.png)
![Services](./md-images/svc.png)

In de web browser van de host zien we onze werkende website.
![Website in Minikube](./md-images/minikube-site.png)

## Helm

$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh

## Terraform

Voor aanvullende informatie over Terraform, zie [Terraform](./terraform/EXTRA_INFO.md)

terraform apply

oci ce cluster create-kubeconfig --cluster-id $(terraform output -raw cluster_id) --file $HOME/.kube/config --region $(terraform output -raw region)