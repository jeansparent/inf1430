#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

if [[ -z "$1" ]]; then
    export TF_VAR_vm_size="Standard_B1s"
else
    export TF_VAR_vm_size="$1"
fi

# Vérification de la variable d'environnement TF_VAR_subscription_id
if [[ -z "${TF_VAR_subscription_id}" ]]; then
  echo "Please configure ENV TF_VAR_subscription_id."
  echo "You can use this command: "
  echo "export TF_VAR_subscription_id='ORG_ID'"
  exit 1
fi

if [[ -z "${TF_VAR_public_rsa}" ]]; then
  echo "Please configure ENV TF_VAR_public_rsa."
  echo "You can use this command: "
  echo "export TF_VAR_public_rsa='Public RSA KEY'"
  exit 1
fi

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Déploiement du Terraform pour Memoire
terraform -chdir=$SCRIPTPATH/VM init
terraform -chdir=$SCRIPTPATH/VM plan -out memoire-vm.plan
terraform -chdir=$SCRIPTPATH/VM apply "memoire-vm.plan"