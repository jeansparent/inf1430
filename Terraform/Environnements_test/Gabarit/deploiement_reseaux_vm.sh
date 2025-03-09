#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

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

# Déploiement du Terraform pour Processeur
terraform -chdir=$SCRIPTPATH/VM init
terraform -chdir=$SCRIPTPATH/VM plan -out processeur-vm.plan
terraform -chdir=$SCRIPTPATH/VM apply "processeur-vm.plan"