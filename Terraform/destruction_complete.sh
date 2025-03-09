#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

terraform -chdir=$SCRIPTPATH/Environnements_test/Demarrage/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Demarrage/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Reseaux/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Reseaux/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Bastion destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/VNET destroy -auto-approve || true

find . -name ".terraform" -type d -exec rm -rf {} + 
find . -name "terraform.tfstate*" -type f -delete
find . -name "*.plan" -type f -delete
find . -name ".terraform.lock.hcl" -type f -delete