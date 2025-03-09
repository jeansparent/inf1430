#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 9 mars 2025

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

# Déploiement du Terraform pour Reseaux
terraform -chdir=$SCRIPTPATH/Docker init
terraform -chdir=$SCRIPTPATH/Docker plan -out reseaux-docker.plan
terraform -chdir=$SCRIPTPATH/Docker apply "reseaux-docker.plan"