#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

# Variables
ENVIRONNEMENT=""
help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --env) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                ENVIRONNEMENT="$2"
                shift  
            else
                echo "Erreur : --env nécessite une valeur (ex: --env dev)"
                exit 1
            fi
            ;;
        --instance)
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                export TF_VAR_vm_size="$2"
                shift  
            fi
            ;;
        --region)
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                export TF_VAR_region="$2"
                shift  
            fi
            ;;
        --help) 
            help=true
            ;;
        --) 
            shift
            break
            ;;
        *) 
            echo "Option inconnue : $1"
            exit 1
            ;;
    esac
    shift
done

if $help; then
    echo "Usage: $0 [--env <valeur>] [--instance <valeur>] [--region <valeur>] [--help]"
    echo "  --env val    Spécifie l'environnement"
    echo "  --instance val    Spécifie l'instance"
    echo "  --region val    Spécifie la région (ex: eastus)"
    echo "  --help         Affiche cette aide"
    exit 0
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

# Déploiement du Terraform pour Dev-VM
terraform -chdir=$PWD/Terraform/$ENVIRONNEMENT init
terraform -chdir=$PWD/Terraform/$ENVIRONNEMENT plan -out $ENVIRONNEMENT.plan
terraform -chdir=$PWD/Terraform/$ENVIRONNEMENT apply "$ENVIRONNEMENT.plan"