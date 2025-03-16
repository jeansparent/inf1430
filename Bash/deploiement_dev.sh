#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 13 mars 2025

# Script
export ANSIBLE_HOST_KEY_CHECKING=False
bash $PWD/Bash/Terraform/deploiement_env.sh --env Dev_VM
external_ip=$(terraform -chdir="$PWD/Terraform/Dev_VM" output -raw public_ip)

echo "Attente de la disponibilité de SSH sur $HOST..."
while ! nc -z $external_ip 22; do
  echo "SSH pas encore disponible. Attente..."
  sleep 5
done

sed -i -e "s/x.x.x.x/$external_ip/g" $PWD/Ansible/inventory.yaml
ansible-playbook -i $PWD/Ansible/inventory.yaml $PWD/Ansible/dev.yaml
sed -i -e "s/$external_ip/x.x.x.x/g" $PWD/Ansible/inventory.yaml