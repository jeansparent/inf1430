#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

ENVIRONNEMENT=""
REGION=""
SIZE=""
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
                SIZE="$2"
                shift  
            fi
            ;;
        --region)
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                REGION="$2"
                shift  
            fi
            ;;
        --help) help=true ;;
        --) shift; break ;;
        *) echo "Option inconnue : $1"; exit 1 ;;
    esac
    shift
done

if $help; then
    echo "Usage: $0 [--env <valeur>] [--help]"
    echo "  --env val    Spécifie l'environnement"
    echo "  --instance val    Spécifie l'instance"
    echo "  --region val    Spécifie l'environnement"
    echo "  --help         Affiche cette aide"
    exit 0
fi

# Script
export ANSIBLE_HOST_KEY_CHECKING=False
bash $PWD/Bash/Terraform/deploiement_env.sh --env VNET --region $REGION
bash $PWD/Bash/Terraform/deploiement_env.sh --env Bastion --region $REGION --instance $SIZE
external_ip=$(terraform -chdir="$PWD/Terraform/Bastion" output -raw public_ip)

echo "Attente de la disponibilité de SSH sur $HOST..."
while ! nc -z $external_ip 22; do
  echo "SSH pas encore disponible. Attente..."
  sleep 5
done

sed -i -e "s/b.b.b.b/$external_ip/g" $PWD/Ansible/inventory.yaml
ansible-playbook -i $PWD/Ansible/inventory.yaml $PWD/Ansible/bastion.yaml