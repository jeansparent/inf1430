#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 9 mars 2025

case "$1" in
    "Standard_B1s"*) 
        export TF_VAR_vm_size="$1"
        ;;
    "Standard_D2as_v5"*) 
        export TF_VAR_vm_size="$1"
        ;;
    "Standard_D8as_v5"*) 
        export TF_VAR_vm_size="$1"
        ;;
    *) 
        echo "Choisir entre Standard_B1s, et"
        echo "Sinon, ne rien mettre comme option pour utiliser Standard_B1s"
        exit 1 
        ;;
    "")
        export TF_VAR_vm_size="Standard_B1s"
        ;;
esac

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

# Déploiement du Terraform pour Disque
terraform -chdir=$SCRIPTPATH/VM init
terraform -chdir=$SCRIPTPATH/VM plan -out disque-vm.plan
terraform -chdir=$SCRIPTPATH/VM apply "disque-vm.plan"