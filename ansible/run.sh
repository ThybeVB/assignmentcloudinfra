#!/bin/bash

ansible-playbook push-docker-app.yaml
ansible-playbook apply-terraform.yaml
ansible-playbook apply-helm.yaml