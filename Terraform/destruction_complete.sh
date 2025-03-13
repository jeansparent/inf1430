#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

if [[ -z "$1" ]]; then
    export TF_VAR_vm_size="Standard_B1s"
else
    export TF_VAR_vm_size="$1"
fi

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

terraform -chdir=$SCRIPTPATH/Environnements_test/Demarrage/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Demarrage/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Reseaux/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Reseaux/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Disque/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Disque/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Memoire/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Memoire/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Processeur/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Processeur/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/SCP/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/SCP/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Applicatif/VM destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Environnements_test/Applicatif/Docker destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/Bastion destroy -auto-approve || true
terraform -chdir=$SCRIPTPATH/VNET destroy -auto-approve || true

find . -name ".terraform" -type d -exec rm -rf {} + 
find . -name "terraform.tfstate*" -type f -delete
find . -name "*.plan" -type f -delete
find . -name ".terraform.lock.hcl" -type f -delete