#!/bin/bash

ansible-playbook push-docker-app.yaml
ansible-playbook apply-helm.yaml