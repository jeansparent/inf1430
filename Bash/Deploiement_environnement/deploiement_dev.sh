#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 13 mars 2025

export ANSIBLE_HOST_KEY_CHECKING=False

echo "[Dev] dev-server ansible_host=$working_folder ansible_user=administrateur" > temp_inventory.ini

ansible-playbook -i temp_inventory.ini playbook.yml

working_folder="$PWD"

bash $working_folder/Terraform/deploiement_env_dev.sh

external_ip=$(terraform -chdir="$working_folder/Terraform/Dev-VM" output -raw public_ip)


echo "[Dev] dev-server ansible_host=$external_ip ansible_user=administrateur" > temp_inventory.ini
ansible-playbook -i temp_inventory.ini playbook.yml