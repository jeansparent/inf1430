#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

# Variables
ENVIRONNEMENT=""
help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
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
        --env) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                ENVIRONNEMENT="$2"
                shift  
            else
                echo "Erreur : --env nécessite une valeur (ex: --env dev)"
                exit 1
            fi
            ;;
        --help) help=true ;;
        --) shift; break ;;
        *) echo "Option inconnue : $1"; exit 1 ;;
    esac
    shift
done

if $help; then
    echo "Usage: $0 [--instance <valeur>] [--env <valeur>] [--help]"
    echo "  --instance val      Specifie le type d'instance"
    echo "  --region val      Specifie la region"
    echo "  --env val    Spécifie l'environnement"
    echo "  --help         Affiche cette aide"
    exit 0
fi

# Script
echo "Destruction de l'environnement $PWD/Terraform/$ENVIRONNEMENT"
terraform -chdir=$PWD/Terraform/$ENVIRONNEMENT destroy -auto-approve
