#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

# Script
export ANSIBLE_HOST_KEY_CHECKING=False
bash $PWD/Bash/Terraform/deploiement_env.sh --env VNET
bash $PWD/Bash/Terraform/deploiement_env.sh --env Bastion
external_ip=$(terraform -chdir="$PWD/Terraform/Bastion" output -raw public_ip)

sed -i -e "s/x.x.x.x/$external_ip/g" $PWD/Ansible/inventory.yaml
ansible-playbook -i $PWD/Ansible/inventory.yaml $PWD/Ansible/env-dev.yaml
sed -i -e "s/$external_ip/x.x.x.x/g" $PWD/Ansible/inventory.yaml